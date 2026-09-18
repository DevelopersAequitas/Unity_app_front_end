import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/menu_summary_model.dart';
import '../models/notification_preferences_model.dart';

abstract class MenuRemoteDataSource {
  Future<MenuSummaryModel> getMenuSummary();
  Future<NotificationPreferencesModel> getNotificationPreferences();
  Future<NotificationPreferencesModel> updateNotificationPreferences(Map<String, dynamic> data);
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final DioClient dioClient;

  const MenuRemoteDataSourceImpl(this.dioClient);

  @override
  Future<MenuSummaryModel> getMenuSummary() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.p2pMeetingRequestsInbox);
      int meetingRequests = 0;
      if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        final items = map['data']?['items'] as List? ?? map['items'] as List? ?? [];
        meetingRequests = items.length;
      }
      return MenuSummaryModel(meetingRequestsCount: meetingRequests);
    } catch (_) {
      return const MenuSummaryModel();
    }
  }

  @override
  Future<NotificationPreferencesModel> getNotificationPreferences() async {
    final response = await dioClient.dio.get(ApiEndpoints.notificationPreferences);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final map = data['data'] as Map<String, dynamic>? ?? data;
      return NotificationPreferencesModel.fromJson(map);
    }
    return const NotificationPreferencesModel();
  }

  @override
  Future<NotificationPreferencesModel> updateNotificationPreferences(Map<String, dynamic> data) async {
    try {
      final response = await dioClient.dio.put(ApiEndpoints.notificationPreferences, data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic>) {
        final map = resData['data'] as Map<String, dynamic>? ?? resData;
        return NotificationPreferencesModel.fromJson(map);
      }
    } catch (_) {
      try {
        final response = await dioClient.dio.patch(ApiEndpoints.notificationPreferences, data: data);
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          final map = resData['data'] as Map<String, dynamic>? ?? resData;
          return NotificationPreferencesModel.fromJson(map);
        }
      } catch (_) {
        final response = await dioClient.dio.post(ApiEndpoints.notificationPreferences, data: data);
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          final map = resData['data'] as Map<String, dynamic>? ?? resData;
          return NotificationPreferencesModel.fromJson(map);
        }
      }
    }
    return NotificationPreferencesModel.fromJson(data);
  }
}

