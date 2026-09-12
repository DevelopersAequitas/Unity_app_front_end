import '../../domain/entities/peer_request_entity.dart';
import 'peer_model.dart';

class PeerRequestModel {
  final String id;
  final bool isApproved;
  final DateTime? createdAt;
  final PeerModel peer;

  const PeerRequestModel({
    required this.id,
    this.isApproved = false,
    this.createdAt,
    required this.peer,
  });

  factory PeerRequestModel.fromJson(Map<String, dynamic> json, {bool isSent = false}) {
    Map<String, dynamic> peerMap = {};
    if (isSent) {
      if (json['user'] is Map) {
        peerMap = json['user'] as Map<String, dynamic>;
      } else if (json['addressee'] is Map) {
        peerMap = json['addressee'] as Map<String, dynamic>;
      } else if (json['receiver'] is Map) {
        peerMap = json['receiver'] as Map<String, dynamic>;
      } else if (json['to_user'] is Map) {
        peerMap = json['to_user'] as Map<String, dynamic>;
      } else if (json['member'] is Map) {
        peerMap = json['member'] as Map<String, dynamic>;
      } else {
        peerMap = json;
      }
    } else {
      if (json['requester'] is Map) {
        peerMap = json['requester'] as Map<String, dynamic>;
      } else if (json['sender'] is Map) {
        peerMap = json['sender'] as Map<String, dynamic>;
      } else if (json['user'] is Map) {
        peerMap = json['user'] as Map<String, dynamic>;
      } else if (json['from_user'] is Map) {
        peerMap = json['from_user'] as Map<String, dynamic>;
      } else if (json['member'] is Map) {
        peerMap = json['member'] as Map<String, dynamic>;
      } else {
        peerMap = json;
      }
    }

    return PeerRequestModel(
      id: json['id']?.toString() ?? '',
      isApproved: json['is_approved'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      peer: PeerModel.fromJson(peerMap),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_approved': isApproved,
      'created_at': createdAt?.toIso8601String(),
      'user': peer.toJson(),
    };
  }

  PeerRequestEntity toEntity() {
    return PeerRequestEntity(
      id: id,
      isApproved: isApproved,
      createdAt: createdAt,
      peer: peer.toEntity(),
    );
  }
}
