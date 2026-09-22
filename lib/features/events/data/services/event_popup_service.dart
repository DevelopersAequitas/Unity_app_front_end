import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/ad_model.dart';
import '../models/event_popup_model.dart';
import '../../presentation/widgets/event_popup_bottom_sheet.dart';

class EventPopupService {
  static final EventPopupService _instance = EventPopupService._internal();
  static EventPopupService get instance => _instance;
  EventPopupService._internal();

  final DioClient _dioClient = DioClient();
  bool _hasShownThisSession = false;

  static const String _boxName = 'event_popup_preferences';
  static const String _eventCycleKey = 'event_popup_cycle_index';
  static const String _adCycleKey = 'ad_popup_cycle_index';

  Future<Box> _getPrefsBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return await Hive.openBox(_boxName);
  }

  /// Fetches all active event popups from `/events/all-with-live-status`.
  Future<List<EventPopupModel>> fetchEventPopups() async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.allEventsWithLiveStatus,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic body = response.data;
        if (body is Map<String, dynamic> && body['data'] != null) {
          final data = body['data'];
          final List<dynamic> rawItems = [];

          if (data is List) {
            rawItems.addAll(data);
          } else if (data is Map<String, dynamic>) {
            if (data['live_events'] is List) {
              rawItems.addAll(data['live_events'] as List);
            }
            if (data['today_events'] is List) {
              rawItems.addAll(data['today_events'] as List);
            }
            if (data['upcoming_events'] is List) {
              rawItems.addAll(data['upcoming_events'] as List);
            }
            if (data['items'] is List) {
              rawItems.addAll(data['items'] as List);
            }
          }

          final Set<String> seenIds = {};
          final List<EventPopupModel> popups = [];

          for (final item in rawItems) {
            if (item is Map<String, dynamic>) {
              final popup = EventPopupModel.fromLiveStatusEvent(item);
              final uniqueKey = '${popup.eventId}_${popup.occurrenceId ?? ""}';
              if (!seenIds.contains(uniqueKey)) {
                seenIds.add(uniqueKey);
                popups.add(popup);
              }
            }
          }

          return popups;
        }
      }
      return [];
    } catch (e) {
      debugPrint('[EventPopupService] fetchEventPopups error: $e');
      return [];
    }
  }

  /// Fetches advertisements from `ApiEndpoints.ads`.
  Future<List<AdModel>> fetchAds() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.ads);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic body = response.data;
        if (body is Map<String, dynamic> && body['data'] != null) {
          final dataList = body['data'];
          if (dataList is List) {
            return dataList
                .whereType<Map<String, dynamic>>()
                .map((json) => AdModel.fromJson(json))
                .toList();
          }
        }
      }
      return [];
    } catch (e) {
      debugPrint('[EventPopupService] fetchAds error: $e');
      return [];
    }
  }

  /// Checks if an event has already ended.
  bool isPopupExpired(EventPopupModel popup) {
    final dateStr = (popup.endDatetime != null && popup.endDatetime!.isNotEmpty)
        ? popup.endDatetime
        : popup.startDatetime;

    if (dateStr != null && dateStr.isNotEmpty) {
      try {
        final eventDate = DateTime.parse(dateStr);
        if (eventDate.isBefore(DateTime.now())) {
          return true;
        }
      } catch (_) {}
    }
    return false;
  }

  /// Automatically displays the popup on Home Screen.
  /// 1. Tries active events first, rotating across restarts.
  /// 2. If no active events exist, falls back to rotating Ads.
  Future<void> showEventPopupIfAvailable(
    BuildContext context, {
    bool force = false,
  }) async {
    if (_hasShownThisSession && !force) return;

    try {
      final box = await _getPrefsBox();

      // 1. Try events first
      final popups = await fetchEventPopups();
      if (!context.mounted) return;

      final activePopups =
          popups.where((p) => p.showPopup && !isPopupExpired(p)).toList();

      if (activePopups.isNotEmpty) {
        final lastIndex = (box.get(_eventCycleKey) as int?) ?? -1;
        final nextIndex = (lastIndex + 1) % activePopups.length;
        await box.put(_eventCycleKey, nextIndex);

        final popupToShow = activePopups[nextIndex];
        _hasShownThisSession = true;

        debugPrint(
          '[EventPopupService] Showing event popup [$nextIndex/${activePopups.length}]: ${popupToShow.eventName}',
        );

        if (!context.mounted) return;

        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => EventPopupBottomSheet(
            popup: popupToShow,
            onClose: () {},
          ),
        );
        return;
      }

      // 2. Fallback to Ads if no active events exist
      debugPrint(
        '[EventPopupService] No active events found. Falling back to Ads...',
      );
      final ads = await fetchAds();
      if (!context.mounted) return;

      if (ads.isNotEmpty) {
        final lastAdIndex = (box.get(_adCycleKey) as int?) ?? -1;
        final nextAdIndex = (lastAdIndex + 1) % ads.length;
        await box.put(_adCycleKey, nextAdIndex);

        final ad = ads[nextAdIndex];
        final adPopup = EventPopupModel(
          eventId: ad.id,
          occurrenceId: null,
          eventName: ad.title.isNotEmpty ? ad.title : 'Sponsored Announcement',
          address: null,
          circleName: 'Sponsored',
          eventType: 'Ad',
          circleId: '',
          imageUrl: ad.imageUrl,
          showPopup: true,
          realtimePopup: false,
          popupTitle: ad.title.isNotEmpty ? ad.title : 'Sponsored Announcement',
          popupMessage: ad.description,
          popupActionUrl: ad.actionUrl,
          popupVersion: 1,
          alreadySeen: false,
          updatedAt: DateTime.now(),
        );

        _hasShownThisSession = true;

        debugPrint(
          '[EventPopupService] Showing Ad popup [$nextAdIndex/${ads.length}]: ${ad.title}',
        );

        if (!context.mounted) return;

        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => EventPopupBottomSheet(
            popup: adPopup,
            onClose: () {},
          ),
        );
        return;
      }

      debugPrint('[EventPopupService] No active events or ads to display.');
    } catch (e) {
      debugPrint('[EventPopupService] Error displaying popup: $e');
    }
  }

  /// Resets the session flag (useful for testing or manual triggers).
  void resetSession() {
    _hasShownThisSession = false;
  }
}
