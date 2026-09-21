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
    try {
      final res = await dioClient.dio.get(ApiEndpoints.adminSupportTickets);
      return _parseTickets(res.data);
    } catch (_) {
      try {
        final res = await dioClient.dio.get(ApiEndpoints.supportTickets);
        return _parseTickets(res.data);
      } catch (_) {
        final res = await dioClient.dio.get(ApiEndpoints.support);
        return _parseTickets(res.data);
      }
    }
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
        raw = inner['items'] as List? ?? inner['tickets'] as List?;
      } else {
        raw = data['items'] as List? ?? data['tickets'] as List?;
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
