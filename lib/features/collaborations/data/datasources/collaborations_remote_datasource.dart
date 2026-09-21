import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/collaboration_params.dart';
import '../models/collaboration_model.dart';
import '../models/collaboration_type_model.dart';
import '../models/industry_model.dart';

abstract class CollaborationsRemoteDataSource {
  Future<List<IndustryParentModel>> getIndustriesTree();
  Future<List<CollaborationTypeModel>> getCollaborationTypes();
  Future<void> submitCollaboration(CollaborationParams params);
  Future<List<CollaborationModel>> getCollaborationHistory();
  Future<void> acceptCollaboration(String collaborationId);
}

class CollaborationsRemoteDataSourceImpl implements CollaborationsRemoteDataSource {
  final DioClient dioClient;

  const CollaborationsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<IndustryParentModel>> getIndustriesTree() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.industriesTree);
      final data = response.data;
      dynamic listData = data;
      if (data is Map<String, dynamic>) {
        listData = data['data'] ?? data['industries'] ?? data;
      }
      if (listData is List) {
        return listData
            .whereType<Map<String, dynamic>>()
            .map((e) => IndustryParentModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint('getIndustriesTree error: $e');
    }
    return [];
  }

  @override
  Future<List<CollaborationTypeModel>> getCollaborationTypes() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.collaborationTypes);
      final data = response.data;
      dynamic listData = data;
      if (data is Map<String, dynamic>) {
        listData = data['data'] ?? data['types'] ?? data;
      }
      if (listData is List) {
        return listData
            .whereType<Map<String, dynamic>>()
            .map((e) => CollaborationTypeModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint('getCollaborationTypes error: $e');
    }
    return [
      const CollaborationTypeModel(id: '1', label: 'Channel Partner / Distributor'),
      const CollaborationTypeModel(id: '2', label: 'Co-Branding / Cross Promotion'),
      const CollaborationTypeModel(id: '3', label: 'Joint Venture / Consortium'),
      const CollaborationTypeModel(id: '4', label: 'Technology / Integration Partner'),
      const CollaborationTypeModel(id: '5', label: 'Vendor / Subcontractor'),
      const CollaborationTypeModel(id: '6', label: 'Investor / Funding Partner'),
    ];
  }

  @override
  Future<void> submitCollaboration(CollaborationParams params) async {
    await dioClient.dio.post(
      ApiEndpoints.collaborations,
      data: params.toJson(),
    );
  }

  @override
  Future<List<CollaborationModel>> getCollaborationHistory() async {
    final endpoints = [
      ApiEndpoints.collaborationHistory,
      ApiEndpoints.collaborations,
    ];

    for (final endpoint in endpoints) {
      try {
        final response = await dioClient.dio.get(endpoint);
        final data = response.data;
        final list = _parseCollaborations(data);
        if (list.isNotEmpty) return list;
      } on DioException catch (e) {
        if (e.response?.statusCode != 404) {
          debugPrint('getCollaborationHistory $endpoint error: $e');
        }
      } catch (e) {
        debugPrint('getCollaborationHistory parse error: $e');
      }
    }
    return [];
  }

  List<CollaborationModel> _parseCollaborations(dynamic data) {
    final list = <CollaborationModel>[];
    if (data is Map<String, dynamic>) {
      final root = data['data'] ?? data;
      if (root is Map<String, dynamic>) {
        final incomplete = root['incomplete'] ?? root['open'] ?? root['items'];
        if (incomplete is List) {
          for (final item in incomplete) {
            if (item is Map<String, dynamic>) list.add(CollaborationModel.fromJson(item));
          }
        }
        final completed = root['completed'];
        if (completed is List) {
          for (final item in completed) {
            if (item is Map<String, dynamic>) list.add(CollaborationModel.fromJson(item));
          }
        }
      } else if (root is List) {
        for (final item in root) {
          if (item is Map<String, dynamic>) list.add(CollaborationModel.fromJson(item));
        }
      }
    } else if (data is List) {
      for (final item in data) {
        if (item is Map<String, dynamic>) list.add(CollaborationModel.fromJson(item));
      }
    }
    return list;
  }

  @override
  Future<void> acceptCollaboration(String collaborationId) async {
    await dioClient.dio.patch(ApiEndpoints.acceptCollaboration(collaborationId));
  }
}
