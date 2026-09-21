import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../highlights/domain/entities/introduced_peer_entity.dart';
import '../../../highlights/presentation/widgets/introduced_peer_tile.dart';
import '../../domain/usecases/get_member_introduced_peers_usecase.dart';

class PeerIntroducedPeersScreen extends StatefulWidget {
  final String peerId;
  final String peerName;
  final List<IntroducedPeerEntity>? initialPeers;

  const PeerIntroducedPeersScreen({
    super.key,
    required this.peerId,
    required this.peerName,
    this.initialPeers,
  });

  @override
  State<PeerIntroducedPeersScreen> createState() =>
      _PeerIntroducedPeersScreenState();
}

class _PeerIntroducedPeersScreenState extends State<PeerIntroducedPeersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<IntroducedPeerEntity> _peers = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialPeers != null && widget.initialPeers!.isNotEmpty) {
      _peers = widget.initialPeers!;
    } else {
      _fetchPeers();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPeers() async {
    setState(() => _isLoading = true);
    try {
      final useCase = context.read<GetMemberIntroducedPeersUseCase>();
      final result = await useCase(widget.peerId);
      if (mounted) {
        setState(() {
          _peers = result;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<IntroducedPeerEntity> get _filteredPeers {
    if (_searchQuery.trim().isEmpty) return _peers;
    final q = _searchQuery.toLowerCase().trim();
    return _peers.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.businessName.toLowerCase().contains(q) ||
          p.designation.toLowerCase().contains(q) ||
          p.city.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
    }).toList();
  }

  void _onSearchClose() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = '${widget.peerName}\'s Introduced Peers';
    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      appBar: AppCommonBar(
        title: title,
        showBack: true,
        showSearch: true,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: 'Search introduced peers...',
        onSearchTap: () => setState(() => _isSearching = true),
        onSearchChanged: (val) => setState(() => _searchQuery = val),
        onSearchClose: _onSearchClose,
        onBackTap: () => Navigator.pop(context),
      ),
      body: _isLoading && _peers.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.primaryBlue,
              ),
            )
          : RefreshIndicator(
              color: AppColor.primaryBlue,
              onRefresh: _fetchPeers,
              child: _filteredPeers.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _filteredPeers.length,
                      itemBuilder: (context, index) =>
                          IntroducedPeerTile(peer: _filteredPeers[index]),
                    ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.people_outline_rounded,
                size: 48,
                color: AppColor.lightTextTertiary,
              ),
              const SizedBox(height: 12),
              Text(
                _searchQuery.isNotEmpty
                    ? 'No introduced peers match "$_searchQuery"'
                    : 'No introduced peers found',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColor.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
