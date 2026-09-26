import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/ask_item_entity.dart';

class ReferralStatusOptionItem {
  final int id;
  final String name;
  final Color color;

  const ReferralStatusOptionItem({
    required this.id,
    required this.name,
    required this.color,
  });
}

class ReferralStatusBottomSheet extends StatelessWidget {
  final String referralId;
  final String referralTitle;
  final int currentStatusId;
  final String? toUserId;
  final String? toUserName;
  final String? toUserCompany;
  final ValueChanged<ReferralStatusOptionItem> onSelectStatus;

  const ReferralStatusBottomSheet({
    super.key,
    required this.referralId,
    required this.referralTitle,
    required this.currentStatusId,
    this.toUserId,
    this.toUserName,
    this.toUserCompany,
    required this.onSelectStatus,
  });

  static const List<ReferralStatusOptionItem> defaultStatuses = [
    ReferralStatusOptionItem(
      id: 1,
      name: 'Not Contacted Yet',
      color: Color(0xFF757575),
    ),
    ReferralStatusOptionItem(
      id: 2,
      name: 'Contacted',
      color: Color(0xFFD97706),
    ),
    ReferralStatusOptionItem(
      id: 3,
      name: 'No Response',
      color: Color(0xFF2563EB),
    ),
    ReferralStatusOptionItem(
      id: 4,
      name: 'Got The Business',
      color: Color(0xFF16A34A),
    ),
    ReferralStatusOptionItem(
      id: 5,
      name: 'Got things done',
      color: Color(0xFF0D9488),
    ),
    ReferralStatusOptionItem(
      id: 6,
      name: 'Did Not Get The Business',
      color: Color(0xFFDC2626),
    ),
    ReferralStatusOptionItem(
      id: 7,
      name: 'Not a Good Fit',
      color: Color(0xFFEA580C),
    ),
    ReferralStatusOptionItem(
      id: 8,
      name: 'Confidential',
      color: Color(0xFF334155),
    ),
  ];

  static Future<void> show(
    BuildContext context, {
    required String referralId,
    required String referralTitle,
    required int currentStatusId,
    String? toUserId,
    String? toUserName,
    String? toUserCompany,
    required ValueChanged<ReferralStatusOptionItem> onSelectStatus,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => ReferralStatusBottomSheet(
        referralId: referralId,
        referralTitle: referralTitle,
        currentStatusId: currentStatusId,
        toUserId: toUserId,
        toUserName: toUserName,
        toUserCompany: toUserCompany,
        onSelectStatus: onSelectStatus,
      ),
    );
  }

  static Future<void> showForAskItem(
    BuildContext context, {
    required AskItemEntity item,
    required ValueChanged<ReferralStatusOptionItem> onSelectStatus,
  }) {
    int statusId = item.rawData['status_id'] is num
        ? (item.rawData['status_id'] as num).toInt()
        : (int.tryParse(item.rawData['status_id']?.toString() ?? '') ?? 1);
    if (statusId <= 0) {
      final name = item.statusLabel.toLowerCase().trim();
      if (name.contains('contacted') && !name.contains('not')) {
        statusId = 2;
      } else if (name.contains('no response')) {
        statusId = 3;
      } else if (name.contains('got the business') || name.contains('fulfilled')) {
        statusId = 4;
      } else if (name.contains('got things done') || name.contains('done')) {
        statusId = 5;
      } else if (name.contains('did not get')) {
        statusId = 6;
      } else if (name.contains('not a good fit') || name.contains('unqualified')) {
        statusId = 7;
      } else if (name.contains('confidential')) {
        statusId = 8;
      } else {
        statusId = 1;
      }
    }

    return show(
      context,
      referralId: item.id,
      referralTitle: item.referralOf.isNotEmpty ? item.referralOf : item.title,
      currentStatusId: statusId,
      toUserId: item.toUserId.isNotEmpty ? item.toUserId : item.authorId,
      toUserName: item.toUserName.isNotEmpty ? item.toUserName : item.authorName,
      toUserCompany: item.toUserCompany.isNotEmpty ? item.toUserCompany : item.authorCompany,
      onSelectStatus: onSelectStatus,
    );
  }

  void _handleStatusTap(BuildContext context, ReferralStatusOptionItem status) {
    final statusId = status.id;
    final cleanName = status.name.trim().toLowerCase();

    if (statusId == 4 || cleanName == 'got the business') {
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        AppRoutes.addBusinessDeal,
        arguments: {
          'referral_id': referralId,
          'to_user_id': toUserId,
          'peer_name': toUserName,
          'company_name': toUserCompany,
        },
      ).then((val) {
        if (val != null) {
          onSelectStatus(status);
          if (context.mounted) {
            AppSnackBar.showSuccess(
              context,
              'Thank you! Business deal saved & status updated to "${status.name}".',
            );
          }
        }
      });
    } else if (statusId == 5 || cleanName == 'got things done') {
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        AppRoutes.addTestimonial,
        arguments: {
          'referral_id': referralId,
          'to_user_id': toUserId,
          'peer_name': toUserName,
          'company_name': toUserCompany,
        },
      ).then((val) {
        if (val != null) {
          onSelectStatus(status);
          if (context.mounted) {
            AppSnackBar.showSuccess(
              context,
              'Thank you! Testimonial appreciation posted & status updated to "${status.name}".',
            );
          }
        }
      });
    } else {
      Navigator.pop(context);
      onSelectStatus(status);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final dividerColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20.0,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    'UPDATE STATUS',
                    style: TextStyle(
                      fontSize: 16,
                      color: titleColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48.0),
                ],
              ),
            ),
            Divider(height: 1, color: dividerColor),

            // Status List Items
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: defaultStatuses.length,
                separatorBuilder: (context, index) => Divider(height: 1, color: dividerColor),
                itemBuilder: (context, index) {
                  final status = defaultStatuses[index];
                  final isSelected = currentStatusId == status.id;

                  return InkWell(
                    onTap: () => _handleStatusTap(context, status),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 14.0,
                            ),
                            child: Text(
                              status.name,
                              style: TextStyle(
                                fontSize: 14.5,
                                color: titleColor,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 50.0,
                          height: 50.0,
                          color: status.color,
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 24.0,
                                )
                              : null,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
