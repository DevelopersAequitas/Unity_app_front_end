import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../router/app_router.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../features/notifications/presentation/bloc/notifications_state.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_state.dart';
import '../../features/chat/presentation/bloc/chat_list/chat_list_bloc.dart';
import '../../features/chat/presentation/bloc/chat_list/chat_list_state.dart';

/// A reusable AppBar for all tabs and screens in the app.
///
/// - [title] — shown as the screen/tab name (e.g., "Home", "Peers")
/// - [showLogo] — if true, renders the brand icon+name instead of [title]
/// - [showSearch] / [showChat] / [showNotifications] / [showProfile] — toggle action icons
/// - [showBack] — renders a back chevron instead of actions (for sub-screens)
/// - [actions] — extra action widgets appended after built-in icons
class AppCommonBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogo;
  final bool showBack;
  final bool showSearch;
  final bool showChat;
  final bool showNotifications;
  final bool showProfile;
  final VoidCallback? onSearchTap;
  final VoidCallback? onChatTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onBackTap;
  final List<Widget>? actions;
  final bool isSearching;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onSearchClose;
  final String? searchHint;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppCommonBar({
    super.key,
    this.title = '',
    this.showLogo = false,
    this.showBack = false,
    this.showSearch = false,
    this.showChat = false,
    this.showNotifications = false,
    this.showProfile = false,
    this.onSearchTap,
    this.onChatTap,
    this.onNotificationsTap,
    this.onProfileTap,
    this.onBackTap,
    this.actions,
    this.isSearching = false,
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchClose,
    this.searchHint,
    this.bottom,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isForcedDark = backgroundColor == Colors.black;
    final bgColor = backgroundColor ?? (isDark ? AppColor.darkBackground : AppColor.lightBackground);
    final iconColor = foregroundColor ?? (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary);
    final primaryTextColor = foregroundColor ?? (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary);

    if (isSearching) {
      return AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: kToolbarHeight,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: (isForcedDark || isDark) ? Brightness.light : Brightness.dark,
          statusBarBrightness: (isForcedDark || isDark) ? Brightness.dark : Brightness.light,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isForcedDark ? Colors.white10 : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, size: 22, color: iconColor),
          onPressed: onSearchClose,
          padding: EdgeInsets.zero,
        ),
        titleSpacing: 0,
        title: TextField(
          controller: searchController,
          autofocus: true,
          onChanged: onSearchChanged,
          onSubmitted: onSearchSubmitted,
          textInputAction: TextInputAction.search,
          style: AppTypography.bodyLarge.copyWith(
            color: primaryTextColor,
            fontSize: 14.5,
          ),
          decoration: InputDecoration(
            hintText: searchHint ?? 'Search...',
            hintStyle: TextStyle(
              color: isDark ? AppColor.darkTextDisabled : AppColor.lightTextDisabled,
              fontSize: 14,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          ),
        ),
        actions: [
          if (searchController != null && searchController!.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.close_rounded, size: 20, color: iconColor),
              onPressed: () {
                searchController!.clear();
                onSearchChanged?.call('');
              },
            ),
          const SizedBox(width: 8),
        ],
      );
    }

    return AppBar(
      backgroundColor: bgColor,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: kToolbarHeight,
      automaticallyImplyLeading: false,
      leading: null,
      titleSpacing: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: (isForcedDark || isDark) ? Brightness.light : Brightness.dark,
        statusBarBrightness: (isForcedDark || isDark) ? Brightness.dark : Brightness.light,
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight((bottom?.preferredSize.height ?? 0) + 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ?bottom,
            Container(
              height: 1,
              color: isForcedDark ? Colors.white10 : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
            ),
          ],
        ),
      ),
      // Build entire row ourselves for exact 16px alignment on both sides
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Back button (uses negative margin to keep visual at edge of 16px zone)
            if (showBack) ...[
              GestureDetector(
                onTap: onBackTap ?? () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.chevron_left_rounded, size: 26, color: iconColor),
                ),
              ),
            ],
            // Title / Logo
            Expanded(
              child: showLogo
                  ? _LogoTitle(isDark: isDark)
                  : Text(
                      title,
                      style: AppTypography.titleMedium.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            // Actions
            ...?actions,
            if (showSearch)
              _IconBtn(icon: Icons.search_rounded, color: iconColor, onTap: onSearchTap),
            if (showChat)
              _ChatBtn(iconColor: iconColor, onTap: onChatTap),
            if (showNotifications)
              _NotificationBtn(iconColor: iconColor, onTap: onNotificationsTap),
            if (showProfile)
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (prev, curr) => prev.user != curr.user,
                builder: (context, authState) => BlocBuilder<ProfileBloc, ProfileState>(
                  buildWhen: (prev, curr) =>
                      prev.profile?.profilePhotoUrl != curr.profile?.profilePhotoUrl ||
                      prev.profile?.firstName != curr.profile?.firstName ||
                      prev.profile?.lastName != curr.profile?.lastName,
                  builder: (context, profileState) => _ProfileAvatar(
                    photoUrl: profileState.profile?.profilePhotoUrl ?? authState.user?.avatarUrl,
                    firstName: profileState.profile?.firstName ?? authState.user?.firstName,
                    lastName: profileState.profile?.lastName ?? authState.user?.lastName,
                    displayName: profileState.profile?.displayName ?? authState.user?.effectiveDisplayName,
                    isDark: isDark,
                    onTap: onProfileTap,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Internal sub-widgets ────────────────────────────────────────────────────

class _LogoTitle extends StatelessWidget {
  final bool isDark;
  const _LogoTitle({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/icon.png', width: 28, height: 28, fit: BoxFit.contain),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            style: AppTypography.titleMedium.copyWith(fontSize: 18),
            children: const [
              TextSpan(text: 'Peers', style: TextStyle(color: AppColor.primaryPink)),
              TextSpan(text: 'Global', style: TextStyle(color: AppColor.primaryBlue)),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const _IconBtn({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: 40,
        height: kToolbarHeight,
        child: Icon(icon, size: 22, color: color),
      ),
    );
  }
}

class _ChatBtn extends StatelessWidget {
  final Color iconColor;
  final VoidCallback? onTap;
  const _ChatBtn({required this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChatListBloc, ChatListState, int>(
      selector: (state) => state.totalUnreadCount,
      builder: (context, unreadCount) {
        final badgeText = unreadCount > 99 ? '99+' : '$unreadCount';
        return Semantics(
          label: unreadCount > 0 ? '$unreadCount unread messages' : 'Chats',
          button: true,
          child: InkWell(
            onTap: onTap ??
                () => Navigator.of(context).pushNamed(AppRoutes.chatList),
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              width: 40,
              height: kToolbarHeight,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.chat_bubble_outline_rounded,
                      size: 21, color: iconColor),
                  if (unreadCount > 0)
                    Positioned(
                      top: 10,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        constraints:
                            const BoxConstraints(minWidth: 16, minHeight: 16),
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlue,
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

class _NotificationBtn extends StatelessWidget {
  final Color iconColor;
  final VoidCallback? onTap;
  const _NotificationBtn({required this.iconColor, this.onTap});

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
              width: 40,
              height: kToolbarHeight,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.notifications_none_rounded, size: 22, color: iconColor),
                  if (unreadCount > 0)
                    Positioned(
                      top: 10,
                      right: 4,
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

class _ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final String? firstName;
  final String? lastName;
  final String? displayName;
  final bool isDark;
  final VoidCallback? onTap;

  const _ProfileAvatar({
    this.photoUrl,
    this.firstName,
    this.lastName,
    this.displayName,
    required this.isDark,
    this.onTap,
  });

  /// Returns first + last initials e.g. "CM" for "Chirag Mali"
  String get _initials {
    final first = (firstName?.trim().isNotEmpty == true) ? firstName![0].toUpperCase() : null;
    final last = (lastName?.trim().isNotEmpty == true) ? lastName![0].toUpperCase() : null;
    if (first != null && last != null) return '$first$last';
    if (first != null) return first;
    // fallback: first char of displayName
    final dn = displayName?.trim() ?? '';
    return dn.isNotEmpty ? dn[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColor.brandGradient,
        ),
        padding: const EdgeInsets.all(1.5),
        child: ClipOval(
          child: url != null && url.isNotEmpty
              ? Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _initialsWidget(context),
                )
              : _initialsWidget(context),
        ),
      ),
    );
  }

  Widget _initialsWidget(BuildContext context) {
    return Container(
      color: isDark ? AppColor.darkSurface : const Color(0xFFEFF3FF),
      child: Center(
        child: Text(
          _initials,
          style: AppTypography.labelSmall.copyWith(
            color: AppColor.primaryBlue,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
            fontSize: _initials.length > 1 ? 9 : 11,
          ),
        ),
      ),
    );
  }
}
