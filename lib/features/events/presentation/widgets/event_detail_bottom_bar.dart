import 'package:flutter/material.dart';
import 'package:unity_app/features/events/domain/entities/user_registration_info.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/primary_pill_button.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/event_registration_entity.dart';

class EventDetailBottomBar extends StatelessWidget {
  final EventEntity event;
  final EventRegistrationEntity? registration;
  final bool isPro;
  final bool isInEventCircle;
  final bool isRegistering;
  final VoidCallback onAttend;
  final VoidCallback onRequestToAttend;
  final VoidCallback onUpgradeToPro;
  final VoidCallback onProceedToPay;
  final VoidCallback onViewQr;

  const EventDetailBottomBar({
    super.key,
    required this.event,
    this.registration,
    required this.isPro,
    required this.isInEventCircle,
    this.isRegistering = false,
    required this.onAttend,
    required this.onRequestToAttend,
    required this.onUpgradeToPro,
    required this.onProceedToPay,
    required this.onViewQr,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final reg = event.userRegistration ??
        (registration != null
            ? UserRegistrationInfo(
                isRegistered: registration!.isConfirmed,
                registrationId: registration!.registrationId,
                status: registration!.status,
                checkoutUrl: registration!.paymentUrl ?? registration!.checkoutUrl,
                qrToken: registration!.qrToken,
                qrCodeUrl: registration!.qrCodeUrl,
              )
            : null);

    final status = reg?.status?.toLowerCase() ?? '';
    final isPaidOrConfirmed = reg?.isRegistered == true ||
        status == 'registered' ||
        status == 'confirmed' ||
        status == 'attended' ||
        reg?.paymentStatus == 'paid';
    final hasCheckoutUrl = reg?.checkoutUrl != null && reg!.checkoutUrl!.isNotEmpty;

    String btnText;
    VoidCallback? onTap;
    Gradient gradient = AppColor.brandGradient;
    IconData? icon;

    // 1. EVENT ENDED
    if (event.endAt != null && DateTime.now().isAfter(event.endAt!)) {
      btnText = 'Event Ended';
      onTap = null;
      icon = Icons.event_busy_rounded;
    }
    // 2. PRIORITY 0: REQUEST REJECTED BY ADMIN
    else if (status == 'rejected') {
      btnText = 'Request Rejected';
      onTap = null;
      icon = Icons.cancel_outlined;
    }
    // 3. PRIORITY 1: PAYMENT PENDING (Highest Active Priority)
    else if (!isPaidOrConfirmed &&
        (status == 'pending_payment' || reg?.paymentStatus == 'pending' || hasCheckoutUrl) &&
        hasCheckoutUrl) {
      btnText = 'Pay Fees';
      onTap = onProceedToPay;
      icon = Icons.payment_rounded;
      gradient = const LinearGradient(
        colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
      );
    }
    // 4. PRIORITY 2: REQUEST PENDING ADMIN APPROVAL
    else if (!isPaidOrConfirmed &&
        (status == 'requested' || status == 'pending' || status == 'pending_approval')) {
      btnText = 'Pending Approval';
      onTap = null;
      icon = Icons.hourglass_top_rounded;
    }
    // 5. PRIORITY 3: ADMIN APPROVED (Proceed to Pay/Register)
    else if (!isPaidOrConfirmed && status == 'approved') {
      if (hasCheckoutUrl) {
        btnText = 'Pay Fees';
        onTap = onProceedToPay;
        icon = Icons.payment_rounded;
      } else {
        btnText = 'Register Now';
        onTap = onAttend;
        icon = Icons.check_circle_outline_rounded;
      }
    }
    // 6. PRIORITY 4: FULLY REGISTERED / CONFIRMED
    else if (isPaidOrConfirmed) {
      btnText = 'View QR Code';
      onTap = onViewQr;
      icon = Icons.qr_code_rounded;
      gradient = const LinearGradient(
        colors: [Color(0xFF059669), Color(0xFF10B981)],
      );
    }
    // 7. PRO MEMBERSHIP CHECK
    else if (!isPro) {
      btnText = 'Upgrade to Pro to Attend';
      onTap = onUpgradeToPro;
      icon = Icons.workspace_premium_rounded;
    }
    // 8. PRIORITY 5: SAME-CIRCLE MEMBER / GLOBAL (Direct Free Attend)
    else if (isInEventCircle) {
      btnText = "I'm Attending";
      onTap = onAttend;
      icon = Icons.check_circle_outline_rounded;
    }
    // 9. PRIORITY 6: DEFAULT BOOKING (Cross-Circle / Visitor / Request)
    else {
      btnText = 'Request to Attend';
      onTap = onRequestToAttend;
      icon = Icons.send_rounded;
    }

    if (isPaidOrConfirmed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: Color(0xFF10B981),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Registered',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: onViewQr,
                    icon: const Icon(Icons.qr_code_rounded, size: 18, color: Colors.white),
                    label: const Text(
                      'View QR Pass',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: PrimaryPillButton(
          label: btnText,
          onPressed: onTap,
          isLoading: isRegistering,
          gradient: gradient,
          iconData: icon,
          showArrow: false,
          height: 44,
        ),
      ),
    );
  }
}
