import 'package:dio/dio.dart';
import 'package:unity_app/features/events/domain/entities/user_registration_info.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/event_model.dart';
import '../models/event_registration_model.dart';

abstract class EventsRemoteDataSource {
  Future<Map<String, List<EventModel>>> getAllEvents({
    String? circleId,
    String? status,
  });

  Future<EventModel> getEventOccurrenceDetail({
    required String eventId,
    required String occurrenceId,
  });

  Future<EventRegistrationModel> registerEvent({
    required String eventId,
    required String occurrenceId,
    String? couponCode,
    String? reason,
    String? categoryId,
  });

  Future<EventRegistrationModel> registerVisitorEvent({
    required String eventId,
    required String occurrenceId,
    required Map<String, dynamic> visitorData,
    String? couponCode,
  });

  Future<EventRegistrationModel> checkPaymentStatus(String registrationId);

  Future<List<EventRegistrationModel>> getMyEventsWithQr();

  Future<List<UserRegistrationInfo>> fetchMyRegistrations();

  Future<List<UserRegistrationInfo>> fetchMyRegistrationRequests();
}

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final DioClient dioClient;

  EventsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, List<EventModel>>> getAllEvents({
    String? circleId,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{};
    if (circleId != null && circleId.isNotEmpty) {
      queryParams['circle_id'] = circleId;
    }
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final futureEvents = dioClient.dio.get(
      ApiEndpoints.eventsAll,
      queryParameters: queryParams,
    );
    final futureMyRegs = fetchMyRegistrations();
    final futureMyRequests = fetchMyRegistrationRequests();

    final results = await Future.wait([
      futureEvents,
      futureMyRegs,
      futureMyRequests,
    ]);

    final response = results[0] as Response;
    final myRegs = results[1] as List<UserRegistrationInfo>;
    final myRequests = results[2] as List<UserRegistrationInfo>;

    final registrationsByOccId = <String, UserRegistrationInfo>{};
    final registrationsByEventId = <String, UserRegistrationInfo>{};

    for (final reg in myRegs) {
      if (reg.occurrenceId != null && reg.occurrenceId!.isNotEmpty) {
        registrationsByOccId[reg.occurrenceId!] = reg;
      }
      if (reg.eventId != null && reg.eventId!.isNotEmpty) {
        registrationsByEventId[reg.eventId!] = reg;
      }
    }

    for (final req in myRequests) {
      if (req.occurrenceId != null && req.occurrenceId!.isNotEmpty) {
        registrationsByOccId.putIfAbsent(req.occurrenceId!, () => req);
      }
      if (req.eventId != null && req.eventId!.isNotEmpty) {
        registrationsByEventId.putIfAbsent(req.eventId!, () => req);
      }
    }

    EventModel attachUserRegistration(EventModel model) {
      final reg = registrationsByOccId[model.occurrenceId] ??
          registrationsByEventId[model.eventId] ??
          model.userRegistration;
      return model.copyWith(userRegistration: reg);
    }

    final data = response.data;
    final result = <String, List<EventModel>>{
      'today': [],
      'live': [],
      'upcoming': [],
      'past': [],
      'all': [],
    };

    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is Map<String, dynamic>) {
        final todayList = (inner['today_events'] ?? inner['today']) as List<dynamic>? ?? [];
        final liveList = (inner['live_events'] ?? inner['live']) as List<dynamic>? ?? [];
        final upcomingList = (inner['upcoming_events'] ?? inner['upcoming']) as List<dynamic>? ?? [];
        final pastList = (inner['past_events'] ?? inner['past'] ?? inner['completed_events'] ?? inner['history_events'] ?? inner['previous_events']) as List<dynamic>? ?? [];

        result['today'] = todayList
            .whereType<Map<String, dynamic>>()
            .map((e) => attachUserRegistration(EventModel.fromJson(e, defaultGroup: 'today')))
            .toList();

        result['live'] = liveList
            .whereType<Map<String, dynamic>>()
            .map((e) => attachUserRegistration(EventModel.fromJson(e, defaultGroup: 'live')))
            .toList();

        result['upcoming'] = upcomingList
            .whereType<Map<String, dynamic>>()
            .map((e) => attachUserRegistration(EventModel.fromJson(e, defaultGroup: 'upcoming')))
            .toList();

        result['past'] = pastList
            .whereType<Map<String, dynamic>>()
            .map((e) => attachUserRegistration(EventModel.fromJson(e, defaultGroup: 'past')))
            .toList();

        result['all'] = [
          ...result['live']!,
          ...result['today']!,
          ...result['upcoming']!,
          ...result['past']!,
        ];
      } else if (inner is List<dynamic>) {
        final list = inner
            .whereType<Map<String, dynamic>>()
            .map((e) => attachUserRegistration(EventModel.fromJson(e)))
            .toList();
        result['all'] = list;
        result['upcoming'] = list;
      }
    }
    return result;
  }

  @override
  Future<EventModel> getEventOccurrenceDetail({
    required String eventId,
    required String occurrenceId,
  }) async {
    // PRIMARY: private /events/{id} — full rich data (speakers, agenda, etc.)
    // FALLBACK: public occurrence endpoint — for unauthenticated/non-member users
    final futureEventDetail = dioClient.dio
        .get(ApiEndpoints.privateEventDetail(eventId))
        .then((r) => r as Response?)
        .catchError((_) => null as Response?);
    final futureOccurrence = dioClient.dio
        .get(ApiEndpoints.publicEventOccurrence(eventId, occurrenceId))
        .then((r) => r as Response?)
        .catchError((_) => null as Response?);
    final futureMyRegs = fetchMyRegistrations();
    final futureMyRequests = fetchMyRegistrationRequests();

    final results = await Future.wait([
      futureEventDetail,
      futureOccurrence,
      futureMyRegs,
      futureMyRequests,
    ]);

    final detailResponse = results[0]; // private endpoint
    final occResponse = results[1];    // public occurrence, may be null
    final myRegs = results[2] as List<UserRegistrationInfo>;
    final myRequests = results[3] as List<UserRegistrationInfo>;

    // Match registration by occurrenceId or eventId
    UserRegistrationInfo? matchedReg;
    for (final reg in [...myRegs, ...myRequests]) {
      if (reg.occurrenceId == occurrenceId || reg.eventId == eventId) {
        matchedReg = reg;
        break;
      }
    }

    // ── PRIMARY: private /events/{id} ──
    if (detailResponse is Response) {
      final detailData = detailResponse.data;
      if (detailData is Map<String, dynamic> &&
          detailData['data'] is Map<String, dynamic>) {
        final rich = detailData['data'] as Map<String, dynamic>;
        var model = EventModel.fromJson(rich);

        // Find display_date / display_time for this specific occurrence
        String? displayDate;
        String? displayTime;
        for (final listKey in ['occurrences', 'upcoming_occurrences']) {
          if (rich[listKey] is List) {
            for (final occ in (rich[listKey] as List<dynamic>)) {
              if (occ is Map<String, dynamic>) {
                final oid = occ['occurrence_id']?.toString() ??
                    occ['id']?.toString();
                if (oid == occurrenceId) {
                  displayDate = occ['display_date']?.toString();
                  displayTime = occ['display_time']?.toString();
                  // Also pick up user_registration from the occurrence
                  if (matchedReg == null &&
                      occ['user_registration'] is Map<String, dynamic>) {
                    matchedReg = UserRegistrationInfo.fromJson(
                        occ['user_registration'] as Map<String, dynamic>);
                  }
                  break;
                }
              }
            }
            if (displayDate != null) break;
          }
        }
        // Fallback to first occurrence display values if no match
        if (displayDate == null && rich['occurrences'] is List) {
          final occs = rich['occurrences'] as List<dynamic>;
          if (occs.isNotEmpty && occs.first is Map<String, dynamic>) {
            final first = occs.first as Map<String, dynamic>;
            displayDate = first['display_date']?.toString();
            displayTime = first['display_time']?.toString();
          }
        }

        return model.copyWith(
          occurrenceId: occurrenceId,
          displayDate: displayDate,
          displayTime: displayTime,
          userRegistration: matchedReg ?? model.userRegistration,
        );
      }
    }

    // ── FALLBACK: public occurrence endpoint ──
    if (occResponse is Response) {
      final data = occResponse.data;
      if (data is Map<String, dynamic> &&
          data['data'] is Map<String, dynamic>) {
        final occData = data['data'] as Map<String, dynamic>;
        final model = EventModel.fromJson(occData);
        return model.copyWith(
          displayDate: occData['display_date']?.toString(),
          displayTime: occData['display_time']?.toString(),
          userRegistration: matchedReg ?? model.userRegistration,
        );
      }
    }

    throw DioException(
      requestOptions:
          RequestOptions(path: ApiEndpoints.privateEventDetail(eventId)),
      error: 'Could not load event details.',
    );
  }

  @override
  Future<EventRegistrationModel> registerEvent({
    required String eventId,
    required String occurrenceId,
    String? couponCode,
    String? reason,
    String? categoryId,
  }) async {
    final payload = <String, dynamic>{
      'source': 'app',
    };
    if (couponCode != null && couponCode.trim().isNotEmpty) {
      payload['coupon_code'] = couponCode.trim();
    }
    if (reason != null && reason.trim().isNotEmpty) {
      payload['reason'] = reason.trim();
    }
    if (categoryId != null && categoryId.trim().isNotEmpty) {
      payload['business_category_id'] = categoryId.trim();
      payload['category_id'] = categoryId.trim();
      payload['visitor_business_category_id'] = categoryId.trim();
    }

    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.eventRegister(eventId, occurrenceId),
        data: payload,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
        final regData = Map<String, dynamic>.from(data['data'] as Map<String, dynamic>);
        regData['event_id'] ??= eventId;
        regData['occurrence_id'] ??= occurrenceId;
        return EventRegistrationModel.fromJson(regData);
      }
      final map = data is Map<String, dynamic> ? Map<String, dynamic>.from(data) : <String, dynamic>{};
      map['event_id'] ??= eventId;
      map['occurrence_id'] ??= occurrenceId;
      return EventRegistrationModel.fromJson(map);
    } on DioException catch (e) {
      final resData = e.response?.data;
      final statusCode = e.response?.statusCode;

      if (statusCode == 403 || statusCode == 422) {
        // Fallback: Submit cross-circle registration request directly if supported
        try {
          final reqPayload = <String, dynamic>{
            'request_reason': reason != null && reason.trim().isNotEmpty
                ? reason.trim()
                : 'I want to attend this event as a cross-circle member.',
          };
          if (couponCode != null && couponCode.trim().isNotEmpty) {
            reqPayload['coupon_code'] = couponCode.trim();
          }
          if (categoryId != null && categoryId.trim().isNotEmpty) {
            reqPayload['business_category_id'] = categoryId.trim();
            reqPayload['category_id'] = categoryId.trim();
            reqPayload['visitor_business_category_id'] = categoryId.trim();
          }

          final reqResponse = await dioClient.dio.post(
            ApiEndpoints.eventRegistrationRequest(eventId, occurrenceId),
            data: reqPayload,
          );
          final reqData = reqResponse.data;
          if (reqData is Map<String, dynamic> && reqData['data'] is Map<String, dynamic>) {
            final inner = Map<String, dynamic>.from(reqData['data'] as Map<String, dynamic>);
            inner['event_id'] ??= eventId;
            inner['occurrence_id'] ??= occurrenceId;
            inner['status'] ??= 'pending_approval';
            return EventRegistrationModel.fromJson(inner);
          }
          return EventRegistrationModel(
            registrationId: reqData?['data']?['request_id']?.toString() ?? '',
            eventId: eventId,
            occurrenceId: occurrenceId,
            status: 'pending_approval',
            eventTitle: reqData?['message']?.toString() ?? 'Registration request submitted for admin approval.',
          );
        } catch (_) {}

        if (resData is Map<String, dynamic>) {
          final inner = resData['data'] is Map<String, dynamic>
              ? resData['data']
              : (resData['errors'] is Map<String, dynamic> ? resData['errors'] : {});
          final reqStatus = inner['request_status']?.toString();
          final reqId = inner['request_id']?.toString() ?? '';
          final isRequestRequired = inner['request_required'] == true ||
              (resData['errors'] is Map && resData['errors']['request_required'] == true);
          final msg = resData['message']?.toString() ??
              'Registration request submitted for admin approval.';

          if (reqStatus == 'pending' ||
              reqStatus == 'not_requested' ||
              isRequestRequired ||
              resData['success'] == false) {
            return EventRegistrationModel(
              registrationId: reqId,
              eventId: eventId,
              occurrenceId: occurrenceId,
              status: 'pending_approval',
              eventTitle: msg,
            );
          }
        }
      }
      rethrow;
    }
  }

  @override
  Future<EventRegistrationModel> registerVisitorEvent({
    required String eventId,
    required String occurrenceId,
    required Map<String, dynamic> visitorData,
    String? couponCode,
  }) async {
    final payload = Map<String, dynamic>.from(visitorData);
    payload['source'] = 'app';
    if (couponCode != null && couponCode.trim().isNotEmpty) {
      payload['coupon_code'] = couponCode.trim();
    }

    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.eventVisitorRegister(eventId, occurrenceId),
        data: payload,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
        return EventRegistrationModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      return EventRegistrationModel.fromJson(data is Map<String, dynamic> ? data : {});
    } on DioException catch (e) {
      final resData = e.response?.data;
      if (e.response?.statusCode == 403 && resData is Map<String, dynamic>) {
        final inner = resData['data'] is Map<String, dynamic>
            ? resData['data']
            : (resData['errors'] is Map<String, dynamic> ? resData['errors'] : {});
        final reqStatus = inner['request_status']?.toString();
        final reqId = inner['request_id']?.toString() ?? '';
        final msg = resData['message']?.toString();
        if (reqStatus == 'pending' || resData['success'] == false) {
          return EventRegistrationModel(
            registrationId: reqId,
            eventId: eventId,
            occurrenceId: occurrenceId,
            status: 'pending_approval',
            eventTitle: msg,
          );
        }
      }
      rethrow;
    }
  }

  @override
  Future<EventRegistrationModel> checkPaymentStatus(String registrationId) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.eventPaymentStatus(registrationId),
    );
    final data = response.data;
    if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
      return EventRegistrationModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      error: 'Invalid response format for payment status.',
    );
  }

  @override
  Future<List<EventRegistrationModel>> getMyEventsWithQr() async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.myRegistrations,
      );
      final data = response.data;
      List<dynamic> items = [];
      if (data is Map<String, dynamic>) {
        final inner = data['data'];
        if (inner is Map<String, dynamic>) {
          items = (inner['items'] ?? inner['registrations'] ?? inner['data']) as List<dynamic>? ?? [];
        } else if (inner is List) {
          items = inner;
        }
      } else if (data is List) {
        items = data;
      }
      return items
          .whereType<Map<String, dynamic>>()
          .map((e) => EventRegistrationModel.fromJson(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<UserRegistrationInfo>> fetchMyRegistrations() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.myRegistrations);
      final data = response.data;
      List<dynamic> list = [];
      if (data is Map<String, dynamic>) {
        final inner = data['data'];
        if (inner is List) {
          list = inner;
        } else if (inner is Map<String, dynamic>) {
          list = (inner['items'] ?? inner['registrations'] ?? inner['data']) as List<dynamic>? ?? [];
        }
      } else if (data is List) {
        list = data;
      }
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => UserRegistrationInfo.fromJson(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<UserRegistrationInfo>> fetchMyRegistrationRequests() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.myRegistrationRequests);
      final data = response.data;
      List<dynamic> list = [];
      if (data is Map<String, dynamic>) {
        final inner = data['data'];
        if (inner is List) {
          list = inner;
        } else if (inner is Map<String, dynamic>) {
          list = (inner['items'] ?? inner['requests'] ?? inner['data']) as List<dynamic>? ?? [];
        }
      } else if (data is List) {
        list = data;
      }
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => UserRegistrationInfo.fromJson(e))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
