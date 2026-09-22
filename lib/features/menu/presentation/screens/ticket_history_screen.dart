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

  @override
  void initState() {
    super.initState();
    _fetchTicketHistory();
  }

  Future<void> _fetchTicketHistory() async {
    setState(() => _isLoading = true);
    List<dynamic> raw = [];
    try {
      final res = await _dio.dio.get(ApiEndpoints.adminSupportTickets);
      final data = res.data;
      if (data is List) {
        raw = data;
      } else if (data is Map<String, dynamic>) {
        final inner = data['data'];
        if (inner is List) {
          raw = inner;
        } else if (inner is Map<String, dynamic>) {
          raw = (inner['items'] as List?) ?? (inner['tickets'] as List?) ?? [];
        } else {
          raw = (data['items'] as List?) ?? (data['tickets'] as List?) ?? [];
        }
      }
    } catch (_) {
      try {
        final res = await _dio.dio.get(ApiEndpoints.supportTickets);
        final data = res.data;
        if (data is List) {
          raw = data;
        } else if (data is Map<String, dynamic>) {
          final inner = data['data'];
          if (inner is List) {
            raw = inner;
          } else if (inner is Map<String, dynamic>) {
            raw = (inner['items'] as List?) ?? (inner['tickets'] as List?) ?? [];
          }
        }
      } catch (_) {
        try {
          final res = await _dio.dio.get(ApiEndpoints.support);
          final data = res.data;
          if (data is List) {
            raw = data;
          } else if (data is Map<String, dynamic>) {
            final inner = data['data'];
            if (inner is List) {
              raw = inner;
            }
          }
        } catch (_) {
          raw = [];
        }
      }
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
    if (s.contains('progress') || s.contains('waiting') || s.contains('processing') || s.contains('review')) {
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
    if (s.contains('progress') || s.contains('waiting') || s.contains('processing') || s.contains('review')) {
      return const Color(0xFFFFFBEB);
    }
    if (s.contains('cancelled') || s.contains('rejected') || s.contains('failed')) {
      return const Color(0xFFFEF2F2);
    }
    return const Color(0xFFEFF6FF);
  }

  void _showTicketDetails(Map<String, dynamic> ticket) {
    final id = (ticket['id'] ?? ticket['ticket_id'] ?? ticket['ticket_number'] ?? '').toString();
    final subject = (ticket['subject'] ?? ticket['title'] ?? 'Support Request').toString();
    final description = (ticket['description'] ?? ticket['message'] ?? ticket['details'] ?? '').toString();
    final status = (ticket['status'] ?? ticket['state'] ?? 'Pending').toString();
    final department = (ticket['department'] ?? ticket['category'] ?? 'General').toString();
    final priority = (ticket['priority'] ?? 'Medium').toString();
    final createdAt = (ticket['created_at'] ?? ticket['date'] ?? '').toString();
    final adminReply = (ticket['admin_reply'] ?? ticket['reply'] ?? ticket['response'] ?? '').toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Text(
                  'Ticket #$id',
                  style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextTertiary),
                ),
              ],
              const Divider(height: 24),
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
              const SizedBox(height: 16),
              Text(
                'Description',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description.isNotEmpty ? description : 'No description provided.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColor.lightTextPrimary,
                  height: 1.4,
                ),
              ),
              if (adminReply.isNotEmpty) ...[
                const SizedBox(height: 16),
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
                            'Support Response',
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        adminReply,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColor.lightTextPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          Text(
            text,
            style: const TextStyle(fontSize: 11, color: AppColor.lightTextSecondary),
          ),
        ],
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
        child: _buildBody(),
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

    if (_tickets.isEmpty) {
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
                'No Support Tickets',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You have not submitted any support tickets yet. Need help? Create a new ticket.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
              ),
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
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _tickets.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final ticket = _tickets[index];
        final id = (ticket['id'] ?? ticket['ticket_id'] ?? ticket['ticket_number'] ?? '').toString();
        final subject = (ticket['subject'] ?? ticket['title'] ?? 'Support Request').toString();
        final description = (ticket['description'] ?? ticket['message'] ?? ticket['details'] ?? '').toString();
        final status = (ticket['status'] ?? ticket['state'] ?? 'Pending').toString();
        final department = (ticket['department'] ?? ticket['category'] ?? 'General').toString();
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColor.lightSurfaceSubtle,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        department,
                        style: const TextStyle(fontSize: 10, color: AppColor.lightTextSecondary),
                      ),
                    ),
                    if (id.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        '#$id',
                        style: const TextStyle(fontSize: 11, color: AppColor.lightTextTertiary),
                      ),
                    ],
                    const Spacer(),
                    if (createdAt.isNotEmpty)
                      Text(
                        AppDateFormatter.formatDateTime(createdAt),
                        style: const TextStyle(fontSize: 11, color: AppColor.lightTextTertiary),
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
