import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/support_ticket_model.dart';

abstract class SupportRemoteDataSource {
  Future<List<SupportTicketModel>> getSupportTickets();
  Future<void> submitTicket(Map<String, dynamic> payload);
}

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  final DioClient dioClient;

  const SupportRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<SupportTicketModel>> getSupportTickets() async {
    final endpoints = [
      ApiEndpoints.supportTickets,
      ApiEndpoints.support,
      '/me/support-tickets',
      '/support-tickets',
      ApiEndpoints.adminSupportTickets,
    ];

    for (final ep in endpoints) {
      try {
        final res = await dioClient.dio.get(ep);
        final list = _parseTickets(res.data);
        if (list.isNotEmpty || res.statusCode == 200) {
          return list;
        }
      } catch (_) {}
    }
    return [];
  }

  List<SupportTicketModel> _parseTickets(dynamic data) {
    List? raw;
    if (data is List) {
      raw = data;
    } else if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is List) {
        raw = inner;
      } else if (inner is Map<String, dynamic>) {
        raw = inner['data'] as List? ??
            inner['items'] as List? ??
            inner['tickets'] as List? ??
            inner['support_tickets'] as List?;
      } else {
        raw = data['items'] as List? ??
            data['tickets'] as List? ??
            data['support_tickets'] as List? ??
            data['result'] as List?;
      }
    }
    if (raw == null) return [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map((m) => SupportTicketModel.fromJson(m))
        .toList();
  }

  @override
  Future<void> submitTicket(Map<String, dynamic> payload) async {
    try {
      await dioClient.dio.post(ApiEndpoints.support, data: payload);
    } catch (_) {
      try {
        await dioClient.dio.post(ApiEndpoints.supportTickets, data: payload);
      } catch (_) {
        await dioClient.dio.post(ApiEndpoints.feedback, data: payload);
      }
    }
  }
}
