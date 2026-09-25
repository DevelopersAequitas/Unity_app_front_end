import 'package:flutter/material.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import 'submit_ticket_screen.dart';

class TicketHistoryScreen extends StatefulWidget {
  const TicketHistoryScreen({super.key});

  @override
  State<TicketHistoryScreen> createState() => _TicketHistoryScreenState();
}

class _TicketHistoryScreenState extends State<TicketHistoryScreen> {
  final DioClient _dio = DioClient();
  bool _isLoading = true;
  List<Map<String, dynamic>> _tickets = [];
  String _activeFilter = 'All'; // 'All', 'Open', 'Completed'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTicketHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is List) return inner;
      if (inner is Map<String, dynamic>) {
        final sub = inner['data'] ??
            inner['items'] ??
            inner['tickets'] ??
            inner['support_tickets'];
        if (sub is List) return sub;
      }
      final direct = data['items'] ??
          data['tickets'] ??
          data['support_tickets'] ??
          data['result'];
      if (direct is List) return direct;
    }
    return [];
  }

  Future<void> _fetchTicketHistory() async {
    setState(() => _isLoading = true);
    List<dynamic> raw = [];
    final endpoints = [
      ApiEndpoints.supportTickets,
      ApiEndpoints.support,
      '/me/support-tickets',
      '/support-tickets',
      ApiEndpoints.adminSupportTickets,
    ];

    for (final ep in endpoints) {
      try {
        final res = await _dio.dio.get(ep);
        final list = _extractList(res.data);
        if (list.isNotEmpty) {
          raw = list;
          break;
        } else if (res.statusCode == 200 && res.data != null) {
          raw = list;
          break;
        }
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
        _tickets = raw.whereType<Map<String, dynamic>>().toList();
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    final s = status.toLowerCase().trim();
    if (s.contains('resolved') || s.contains('done') || s.contains('success') || s.contains('closed')) {
      return const Color(0xFF10B981);
    }
    if (s.contains('progress') || s.contains('waiting') || s.contains('processing') || s.contains('review') || s.contains('open') || s.contains('pending')) {
      return const Color(0xFFF59E0B);
    }
    if (s.contains('cancelled') || s.contains('rejected') || s.contains('failed')) {
      return AppColor.error;
    }
    return AppColor.primaryBlue;
  }

  Color _getStatusBgColor(String status) {
    final s = status.toLowerCase().trim();
    if (s.contains('resolved') || s.contains('done') || s.contains('success') || s.contains('closed')) {
      return const Color(0xFFECFDF5);
    }
    if (s.contains('progress') || s.contains('waiting') || s.contains('processing') || s.contains('review') || s.contains('open') || s.contains('pending')) {
      return const Color(0xFFFFFBEB);
    }
    if (s.contains('cancelled') || s.contains('rejected') || s.contains('failed')) {
      return const Color(0xFFFEF2F2);
    }
    return const Color(0xFFEFF6FF);
  }

  bool _isTicketCompleted(String status) {
    final s = status.toLowerCase().trim();
    return s.contains('resolved') || s.contains('closed') || s.contains('done') || s.contains('completed') || s.contains('success');
  }

  List<Map<String, dynamic>> get _filteredTickets {
    return _tickets.where((ticket) {
      final status = (ticket['status'] ?? ticket['state'] ?? 'Pending').toString();
      final isCompleted = _isTicketCompleted(status);

      if (_activeFilter == 'Open' && isCompleted) return false;
      if (_activeFilter == 'Completed' && !isCompleted) return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final id = (ticket['id'] ?? ticket['ticket_id'] ?? ticket['ticket_number'] ?? '').toString().toLowerCase();
        final subject = (ticket['subject'] ?? ticket['title'] ?? '').toString().toLowerCase();
        final description = (ticket['description'] ?? ticket['message'] ?? ticket['details'] ?? '').toString().toLowerCase();
        final department = (ticket['department'] ?? ticket['category'] ?? '').toString().toLowerCase();

        return id.contains(q) || subject.contains(q) || description.contains(q) || department.contains(q);
      }
      return true;
    }).toList();
  }

  void _showTicketDetails(Map<String, dynamic> ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _TicketDetailsSheetContent(
        ticket: ticket,
        dio: _dio,
        onCommentAdded: () {
          _fetchTicketHistory();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Support Tickets',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColor.lightTextPrimary,
          ),
        ),
        backgroundColor: AppColor.lightSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColor.lightTextPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColor.primaryBlue),
            tooltip: 'New Ticket',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SubmitTicketScreen()),
              );
              _fetchTicketHistory();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTicketHistory,
        color: AppColor.primaryBlue,
        child: Column(
          children: [
            // Search Bar & Filter Tabs
            Container(
              color: AppColor.lightSurface,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v.trim()),
                    decoration: InputDecoration(
                      hintText: 'Search tickets by subject, #ID, or category...',
                      hintStyle: AppTypography.bodySmall.copyWith(color: AppColor.lightTextTertiary, fontSize: 13),
                      prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColor.lightTextSecondary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColor.lightBackground,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildFilterChip('All', _tickets.length),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Open',
                        _tickets.where((t) => !_isTicketCompleted((t['status'] ?? t['state'] ?? 'Pending').toString())).length,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Completed',
                        _tickets.where((t) => _isTicketCompleted((t['status'] ?? t['state'] ?? 'Pending').toString())).length,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColor.lightBorder),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = _activeFilter == label;
    return InkWell(
      onTap: () => setState(() => _activeFilter = label),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryBlue : AppColor.lightBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColor.primaryBlue : AppColor.lightBorder,
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColor.lightTextPrimary,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.25) : AppColor.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColor.lightTextSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => Container(
          height: 90,
          decoration: BoxDecoration(
            color: AppColor.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.lightBorder),
          ),
        ),
      );
    }

    final filtered = _filteredTickets;

    if (filtered.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent_outlined,
                  size: 32,
                  color: AppColor.primaryBlue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _searchQuery.isNotEmpty
                    ? 'No Matching Tickets'
                    : (_activeFilter == 'Open'
                        ? 'No Open Tickets'
                        : (_activeFilter == 'Completed' ? 'No Completed Tickets' : 'No Support Tickets')),
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _searchQuery.isNotEmpty
                    ? 'Try adjusting your search terms.'
                    : 'You don\'t have any tickets in this filter.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
              ),
              if (_tickets.isEmpty) ...[
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SubmitTicketScreen()),
                    );
                    _fetchTicketHistory();
                  },
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Create New Ticket'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final ticket = filtered[index];
        final ticketNumber = (ticket['ticket_number'] ?? ticket['ticket_id'] ?? ticket['id'] ?? '').toString();
        final subject = (ticket['subject'] ?? ticket['title'] ?? 'Support Request').toString();
        final description = (ticket['description'] ?? ticket['message'] ?? ticket['details'] ?? '').toString();
        final status = (ticket['status'] ?? ticket['state'] ?? 'Pending').toString();
        final department = (ticket['department'] ?? ticket['category'] ?? (ticket['priority'] != null ? '${ticket['priority']} Priority' : 'Support')).toString();
        final createdAt = (ticket['created_at'] ?? ticket['date'] ?? '').toString();

        final statusColor = _getStatusColor(status);
        final statusBg = _getStatusBgColor(status);

        return InkWell(
          onTap: () => _showTicketDetails(ticket),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.lightSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColor.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        subject,
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColor.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColor.lightTextSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColor.lightSurfaceSubtle,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                department,
                                style: const TextStyle(fontSize: 10, color: AppColor.lightTextSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          if (ticketNumber.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                ticketNumber.startsWith('SUP') ? ticketNumber : '#$ticketNumber',
                                style: const TextStyle(fontSize: 11, color: AppColor.lightTextTertiary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (createdAt.isNotEmpty)
                      Text(
                        AppDateFormatter.formatDateTime(createdAt),
                        style: const TextStyle(fontSize: 10.5, color: AppColor.lightTextTertiary),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TicketDetailsSheetContent extends StatefulWidget {
  final Map<String, dynamic> ticket;
  final DioClient dio;
  final VoidCallback onCommentAdded;

  const _TicketDetailsSheetContent({
    required this.ticket,
    required this.dio,
    required this.onCommentAdded,
  });

  @override
  State<_TicketDetailsSheetContent> createState() => _TicketDetailsSheetContentState();
}

class _TicketDetailsSheetContentState extends State<_TicketDetailsSheetContent> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSending = false;
  bool _isLoadingDetails = false;
  late Map<String, dynamic> _ticketData;
  List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
    _ticketData = Map<String, dynamic>.from(widget.ticket);
    _initComments();
    _fetchLiveDetails();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _fetchLiveDetails() async {
    final id = (_ticketData['id'] ?? _ticketData['ticket_id'] ?? '').toString();
    if (id.isEmpty) return;
    setState(() => _isLoadingDetails = true);
    try {
      final res = await widget.dio.dio.get(ApiEndpoints.singleSupportTicket(id));
      if (res.data != null && res.data is Map<String, dynamic>) {
        final d = res.data as Map<String, dynamic>;
        final detail = d['data'] is Map<String, dynamic> ? d['data'] as Map<String, dynamic> : d;
        if (mounted) {
          setState(() {
            _ticketData = {..._ticketData, ...detail};
            _initComments();
            _isLoadingDetails = false;
          });
        }
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingDetails = false);
    }
  }

  void _initComments() {
    final rawComments = _ticketData['comments'] ?? _ticketData['replies'] ?? _ticketData['messages'] ?? _ticketData['notes'];
    if (rawComments is List) {
      _comments = rawComments.whereType<Map<String, dynamic>>().toList();
    }
  }

  Future<void> _sendComment(String ticketId) async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);
    final nowStr = DateTime.now().toIso8601String();

    final newComment = {
      'comment': text,
      'message': text,
      'sender_type': 'user',
      'is_admin': false,
      'created_at': nowStr,
    };

    // Optimistic addition
    setState(() {
      _comments.add(newComment);
      _commentController.clear();
    });

    try {
      final payload = {'message': text, 'comment': text};
      try {
        await widget.dio.dio.post('${ApiEndpoints.supportTickets}/$ticketId/comments', data: payload);
      } catch (_) {
        try {
          await widget.dio.dio.post('${ApiEndpoints.support}/$ticketId/reply', data: payload);
        } catch (_) {
          await widget.dio.dio.post('/support/tickets/$ticketId/reply', data: payload);
        }
      }
      widget.onCommentAdded();
    } catch (_) {
      // Ignored if sent optimistically
    }

    if (mounted) {
      setState(() => _isSending = false);
    }
  }

  Color _getStatusColor(String status) {
    final s = status.toLowerCase().trim();
    if (s.contains('resolved') || s.contains('done') || s.contains('success') || s.contains('closed')) {
      return const Color(0xFF10B981);
    }
    if (s.contains('progress') || s.contains('waiting') || s.contains('processing') || s.contains('review') || s.contains('open') || s.contains('pending')) {
      return const Color(0xFFF59E0B);
    }
    if (s.contains('cancelled') || s.contains('rejected') || s.contains('failed')) {
      return AppColor.error;
    }
    return AppColor.primaryBlue;
  }

  Color _getStatusBgColor(String status) {
    final s = status.toLowerCase().trim();
    if (s.contains('resolved') || s.contains('done') || s.contains('success') || s.contains('closed')) {
      return const Color(0xFFECFDF5);
    }
    if (s.contains('progress') || s.contains('waiting') || s.contains('processing') || s.contains('review') || s.contains('open') || s.contains('pending')) {
      return const Color(0xFFFFFBEB);
    }
    if (s.contains('cancelled') || s.contains('rejected') || s.contains('failed')) {
      return const Color(0xFFFEF2F2);
    }
    return const Color(0xFFEFF6FF);
  }

  Widget _detailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColor.lightTextSecondary),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 11, color: AppColor.lightTextSecondary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticket = _ticketData;
    final id = (ticket['id'] ?? ticket['ticket_id'] ?? ticket['ticket_number'] ?? '').toString();
    final subject = (ticket['subject'] ?? ticket['title'] ?? 'Support Request').toString();
    final description = (ticket['description'] ?? ticket['message'] ?? ticket['details'] ?? '').toString();
    final status = (ticket['status'] ?? ticket['state'] ?? 'Pending').toString();
    final department = (ticket['department'] ?? ticket['category'] ?? 'General').toString();
    final priority = (ticket['priority'] ?? 'Medium').toString();
    final createdAt = (ticket['created_at'] ?? ticket['date'] ?? '').toString();
    final adminReply = (ticket['admin_note'] ?? ticket['admin_reply'] ?? ticket['reply'] ?? ticket['response'] ?? ticket['note'] ?? '').toString();
    final mediaUrl = (ticket['media_url'] ?? ticket['attachment_url'] ?? ticket['image_url'] ?? ticket['file_url'] ?? '').toString();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            subject,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColor.lightTextPrimary,
                            ),
                          ),
                        ),
                        if (_isLoadingDetails) ...[
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColor.primaryBlue),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusBgColor(status),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _getStatusColor(status).withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(status),
                      ),
                    ),
                  ),
                ],
              ),
              if (id.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('Ticket #$id', style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextTertiary)),
              ],
              const Divider(height: 20),
              // Meta info
              Row(
                children: [
                  _detailChip(Icons.folder_outlined, department),
                  const SizedBox(width: 8),
                  _detailChip(Icons.flag_outlined, '$priority Priority'),
                  if (createdAt.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    _detailChip(Icons.access_time_rounded, AppDateFormatter.formatDateTime(createdAt)),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              // Scrollable comments and content
              Expanded(
                child: ListView(
                  children: [
                    Text('Original Request', style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w600, color: AppColor.lightTextSecondary)),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.lightBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColor.lightBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description.isNotEmpty ? description : 'No description provided.',
                            style: AppTypography.bodyMedium.copyWith(color: AppColor.lightTextPrimary, height: 1.4),
                          ),
                          if (mediaUrl.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                mediaUrl,
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (adminReply.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.support_agent_rounded, size: 16, color: Color(0xFF16A34A)),
                                const SizedBox(width: 6),
                                Text(
                                  'Support Team Reply / Note',
                                  style: AppTypography.labelSmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF16A34A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              adminReply,
                              style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextPrimary, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (_comments.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text('Comments & Activity', style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w600, color: AppColor.lightTextSecondary)),
                      const SizedBox(height: 8),
                      ..._comments.map((c) {
                        final isAdmin = c['is_admin'] == true || c['sender_type'] == 'admin' || c['role'] == 'admin';
                        final msg = (c['message'] ?? c['comment'] ?? c['content'] ?? '').toString();
                        final time = (c['created_at'] ?? c['date'] ?? '').toString();
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isAdmin ? const Color(0xFFF0FDF4) : AppColor.lightBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isAdmin ? const Color(0xFFBBF7D0) : AppColor.lightBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isAdmin ? 'Support Team' : 'You',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isAdmin ? const Color(0xFF16A34A) : AppColor.primaryBlue,
                                    ),
                                  ),
                                  if (time.isNotEmpty)
                                    Text(
                                      AppDateFormatter.formatDateTime(time),
                                      style: const TextStyle(fontSize: 10, color: AppColor.lightTextTertiary),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(msg, style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextPrimary)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Comment / Reply composer
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: AppTypography.bodySmall,
                      decoration: InputDecoration(
                        hintText: 'Add a comment or follow-up reply...',
                        hintStyle: AppTypography.bodySmall.copyWith(color: AppColor.lightTextTertiary, fontSize: 12),
                        filled: true,
                        fillColor: AppColor.lightBackground,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColor.lightBorder)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColor.lightBorder)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _isSending ? null : () => _sendComment(id),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColor.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: _isSending
                          ? const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
                          : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
