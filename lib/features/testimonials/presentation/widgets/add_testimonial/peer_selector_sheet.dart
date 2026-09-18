import 'package:flutter/material.dart';
import 'package:unity_app/core/widgets/common_peer_selector_sheet.dart';
import 'package:unity_app/features/peers/domain/entities/peer_entity.dart';
import 'package:unity_app/features/peers/domain/usecases/get_all_peers_usecase.dart';

class PeerSelectorSheet {
  static Future<PeerEntity?> show(
    BuildContext context, {
    GetAllPeersUseCase? getAllPeersUseCase,
    String? selectedPeerId,
    String title = 'Select Peer',
  }) {
    return CommonPeerSelectorSheet.show(
      context,
      getAllPeersUseCase: getAllPeersUseCase,
      selectedPeerId: selectedPeerId,
      title: title,
    );
  }
}
