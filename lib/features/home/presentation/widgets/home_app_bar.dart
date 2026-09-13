import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/peers_logo.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../../../notifications/presentation/bloc/notifications_state.dart';

/// A proper AppBar that uses Flutter's native [AppBar] under the hood so that
/// status bar safe-area, system overlay style, and elevation are all handled
/// correctly by the Scaffold. The brand toolbar content is placed inside.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onProfileTap;

  const HomeAppBar({
    super.key,
    this.onSearchTap,
    this.onNotificationsTap,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkBackground : AppColor.lightBackground;
    final iconColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    return AppBar(
      backgroundColor: bgColor,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: kToolbarHeight,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
        ),
      ),
      titleSpacing: 16,
      title: const PeersLogo(iconSize: 30, showText: true),
      actions: [
        _AppBarIconButton(
          icon: Icons.search_rounded,
          color: iconColor,
          onTap: onSearchTap,
        ),
        _NotificationIconButton(iconColor: iconColor, onTap: onNotificationsTap),
        const SizedBox(width: 4),
        BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (prev, curr) => prev.user != curr.user,
          builder: (context, state) {
            final user = state.user;
            final initials = (user?.effectiveDisplayName.isNotEmpty == true)
                ? user!.effectiveDisplayName[0].toUpperCase()
                : 'U';
            final photoUrl = user?.avatarUrl;
            return GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: 34,
                height: 34,
                margin: const EdgeInsets.only(right: 12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColor.brandGradient,
                ),
                padding: const EdgeInsets.all(1.5),
                child: ClipOval(
                  child: photoUrl != null && photoUrl.isNotEmpty
                      ? Image.network(photoUrl, fit: BoxFit.cover, errorBuilder: (_, _, _) => _initialsWidget(initials, isDark))
                      : _initialsWidget(initials, isDark),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _initialsWidget(String initials, bool isDark) {
    return Container(
      color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
      child: Center(
        child: Text(
          initials,
          style: AppTypography.labelSmall.copyWith(
            color: AppColor.primaryBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _AppBarIconButton({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: 44,
        height: kToolbarHeight,
        child: Icon(icon, size: 24, color: color),
      ),
    );
  }
}

class _NotificationIconButton extends StatelessWidget {
  final Color iconColor;
  final VoidCallback? onTap;

  const _NotificationIconButton({required this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NotificationsBloc, NotificationsState, int>(
      selector: (state) => state.unreadCount,
      builder: (context, unreadCount) {
        final badgeText = unreadCount > 99 ? '99+' : '$unreadCount';
        return Semantics(
          label: unreadCount > 0 ? '$unreadCount unread notifications' : 'Notifications',
          button: true,
          child: InkWell(
            onTap: onTap ?? () => Navigator.of(context).pushNamed(AppRoutes.notifications),
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              width: 44,
              height: kToolbarHeight,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.notifications_none_rounded, size: 24, color: iconColor),
                  if (unreadCount > 0)
                    Positioned(
                      top: 10,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        decoration: BoxDecoration(
                          color: AppColor.primaryPink,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Center(
                          child: Text(
                            badgeText,
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
