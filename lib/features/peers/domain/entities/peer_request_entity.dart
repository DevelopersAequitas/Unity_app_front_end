import 'package:equatable/equatable.dart';
import 'peer_entity.dart';

class PeerRequestEntity extends Equatable {
  final String id;
  final bool isApproved;
  final DateTime? createdAt;
  final PeerEntity peer;

  const PeerRequestEntity({
    required this.id,
    this.isApproved = false,
    this.createdAt,
    required this.peer,
  });

  @override
  List<Object?> get props => [id, isApproved, createdAt, peer];
}
