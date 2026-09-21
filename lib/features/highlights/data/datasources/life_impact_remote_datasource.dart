import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/submit_life_impact_params.dart';
import '../models/life_impact_history_model.dart';
import '../models/life_impact_model.dart';

abstract class LifeImpactRemoteDataSource {
  Future<LifeImpactHistoryModel> getLifeImpactHistory();
  Future<List<String>> getLifeImpactActions();
  Future<void> submitLifeImpact(SubmitLifeImpactParams params);
}

class LifeImpactRemoteDataSourceImpl implements LifeImpactRemoteDataSource {
  final DioClient dioClient;
  const LifeImpactRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<LifeImpactHistoryModel> getLifeImpactHistory() async {
    final response = await dioClient.dio.get(ApiEndpoints.lifeImpactHistory);
    final data = response.data['data'];
    if (data is Map<String, dynamic>) {
      return LifeImpactHistoryModel.fromJson(data);
    } else if (data is List) {
      final items = data
          .whereType<Map<String, dynamic>>()
          .map((e) => LifeImpactModel.fromJson(e))
          .toList();
      final total = items.fold<int>(0, (sum, item) => sum + item.impactValue);
      return LifeImpactHistoryModel(totalLifeImpacted: total, items: items);
    }
    return const LifeImpactHistoryModel();
  }

  @override
  Future<List<String>> getLifeImpactActions() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.lifeImpactActions);
      final data = response.data;
      // Response: { "data": { "actions": ["string1", "string2", ...] } }
      List<dynamic>? rawList;
      if (data is Map<String, dynamic>) {
        final inner = data['data'];
        if (inner is Map<String, dynamic>) {
          rawList = inner['actions'] as List<dynamic>?;
        } else if (inner is List) {
          rawList = inner;
        } else if (data['actions'] is List) {
          rawList = data['actions'] as List<dynamic>;
        }
      } else if (data is List) {
        rawList = data;
      }
      if (rawList != null && rawList.isNotEmpty) {
        final list = rawList
            .map((e) => e.toString().trim())
            .where((s) => s.isNotEmpty)
            // encode as "value|||label" — same string for both
            .map((s) => '$s|||$s')
            .toList();
        if (list.isNotEmpty) return list;
      }
    } catch (e) {
      // ignore: avoid_print
      print('[LifeImpact] Actions fetch failed: $e — using fallback');
    }
    // Fallback: real action strings from the /impacts/actions API
    return const [
      'Mentorship - Mentored a Peer with experience & guidance|||Mentorship - Mentored a Peer with experience & guidance',
      'Joint Venture - Connected Peers for a collaboration opportunity|||Joint Venture - Connected Peers for a collaboration opportunity',
      'Knowledge Sharing - Shared knowledge or insight with a Peer|||Knowledge Sharing - Shared knowledge or insight with a Peer',
      'Problem Solving - Helped a Peer overcome a business challenge|||Problem Solving - Helped a Peer overcome a business challenge',
      'Vendor Connect - Helped a Peer find the right vendor or service|||Vendor Connect - Helped a Peer find the right vendor or service',
      'Funding Access - Helped a Peer access funding or capital|||Funding Access - Helped a Peer access funding or capital',
      'Visibility & PR - Helped a Peer get featured or recognised|||Visibility & PR - Helped a Peer get featured or recognised',
      'Emotional Support - Helped a Peer through a personal challenge|||Emotional Support - Helped a Peer through a personal challenge',
      'Execution Support - Helped a Peer get the right things done|||Execution Support - Helped a Peer get the right things done',
    ];
  }

  @override
  Future<void> submitLifeImpact(SubmitLifeImpactParams params) async {
    await dioClient.dio.post(ApiEndpoints.lifeImpact, data: params.toJson());
  }
}
