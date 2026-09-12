import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';

/// A reusable AppBar for all tabs and screens in the app.
///
/// - [title] — shown as the screen/tab name (e.g., "Home", "Peers")
/// - [showLogo] — if true, renders the brand icon+name instead of [title]
/// - [showSearch] / [showNotifications] / [showProfile] — toggle action icons
/// - [showBack] — renders a back chevron instead of actions (for sub-screens)
/// - [actions] — extra action widgets appended after built-in icons
class AppCommonBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogo;
  final bool showBack;
  final bool showSearch;
  final bool showNotifications;
  final bool showProfile;
  final VoidCallback? onSearchTap;
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

  const AppCommonBar({
    super.key,
    this.title = '',
    this.showLogo = false,
    this.showBack = false,
    this.showSearch = true,
    this.showNotifications = true,
    this.showProfile = true,
    this.onSearchTap,
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
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkBackground : AppColor.lightBackground;
    final iconColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

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
      leading: showBack
          ? IconButton(
              icon: Icon(Icons.chevron_left_rounded, size: 24, color: iconColor),
              onPressed: onBackTap ?? () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
            )
          : null,
      titleSpacing: showBack ? 0 : 16,
      title: showLogo
          ? _LogoTitle(isDark: isDark)
          : Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                color: primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
      actions: [
        ...?actions,
        if (showSearch)
          _IconBtn(icon: Icons.search_rounded, color: iconColor, onTap: onSearchTap),
        if (showNotifications)
          _NotificationBtn(iconColor: iconColor, onTap: onNotificationsTap),
        if (showProfile)
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (prev, curr) => prev.user != curr.user,
            builder: (context, state) => _ProfileAvatar(
              user: state.user,
              isDark: isDark,
              onTap: onProfileTap,
            ),
          ),
        const SizedBox(width: 8),
      ],
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

class _NotificationBtn extends StatelessWidget {
  final Color iconColor;
  final VoidCallback? onTap;
  const _NotificationBtn({required this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: 40,
        height: kToolbarHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.notifications_none_rounded, size: 22, color: iconColor),
            Positioned(
              top: 13,
              right: 8,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColor.primaryPink,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final dynamic user;
  final bool isDark;
  final VoidCallback? onTap;
  const _ProfileAvatar({this.user, required this.isDark, this.onTap});

  @override
  Widget build(BuildContext context) {
    final initials = (user?.effectiveDisplayName?.isNotEmpty == true)
        ? user!.effectiveDisplayName[0].toUpperCase()
        : 'U';
    final photoUrl = user?.avatarUrl as String?;

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
          child: photoUrl != null && photoUrl.isNotEmpty
              ? Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _initials(initials, isDark),
                )
              : _initials(initials, isDark),
        ),
      ),
    );
  }

  Widget _initials(String text, bool isDark) {
    return Container(
      color: isDark ? AppColor.darkSurface : const Color(0xFFEFF3FF),
      child: Center(
        child: Text(
          text,
          style: AppTypography.labelSmall.copyWith(
            color: AppColor.primaryBlue,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
