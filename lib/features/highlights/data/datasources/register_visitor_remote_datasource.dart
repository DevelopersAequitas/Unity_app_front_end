import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/event_item_model.dart';
import '../models/register_visitor_model.dart';

abstract class RegisterVisitorRemoteDataSource {
  Future<void> submitRegisterVisitor(RegisterVisitorModel model);
  Future<List<RegisterVisitorModel>> getRegisterVisitorSubmissions();
  Future<List<EventItemModel>> getEvents();
}

class RegisterVisitorRemoteDataSourceImpl
    implements RegisterVisitorRemoteDataSource {
  final DioClient dioClient;

  const RegisterVisitorRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<void> submitRegisterVisitor(RegisterVisitorModel model) async {
    await dioClient.dio.post(
      ApiEndpoints.registerVisitor,
      data: model.toJson(),
    );
  }

  @override
  Future<List<RegisterVisitorModel>> getRegisterVisitorSubmissions() async {
    final response = await dioClient.dio.get(ApiEndpoints.registerVisitorMy);
    final data = response.data;
    List<dynamic> items = [];
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is Map<String, dynamic> && inner['items'] is List) {
        items = inner['items'] as List;
      } else if (inner is List) {
        items = inner;
      }
    } else if (data is List) {
      items = data;
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map((e) => RegisterVisitorModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<EventItemModel>> getEvents() async {
    final response = await dioClient.dio.get(ApiEndpoints.events);
    final data = response.data;
    List<dynamic> items = [];
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is Map<String, dynamic>) {
        final liveEvents = inner['live_events'] as List? ?? [];
        final todayEvents = inner['today_events'] as List? ?? [];
        final upcomingEvents = inner['upcoming_events'] as List? ?? [];
        final genericEvents = inner['events'] as List? ?? inner['items'] as List? ?? [];

        items = [
          ...liveEvents,
          ...todayEvents,
          ...upcomingEvents,
          ...genericEvents,
        ];
      } else if (inner is List) {
        items = inner;
      } else {
        final liveEvents = data['live_events'] as List? ?? [];
        final todayEvents = data['today_events'] as List? ?? [];
        final upcomingEvents = data['upcoming_events'] as List? ?? [];
        final genericItems = data['items'] as List? ?? data['events'] as List? ?? [];
        items = [
          ...liveEvents,
          ...todayEvents,
          ...upcomingEvents,
          ...genericItems,
        ];
      }
    } else if (data is List) {
      items = data;
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map((e) => EventItemModel.fromJson(e))
        .toList();
  }
}
