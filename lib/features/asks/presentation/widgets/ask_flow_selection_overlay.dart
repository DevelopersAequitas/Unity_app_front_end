import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/entities/ask_flow_entity.dart';
import '../bloc/ask_flows_bloc.dart';
import '../bloc/ask_flows_event.dart';
import '../bloc/ask_flows_state.dart';

class AskFlowSelectionOverlay extends StatefulWidget {
  static bool hasShownInSession = false;

  const AskFlowSelectionOverlay({super.key});

  static Future<void> show(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AskFlowSelectionOverlay(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  State<AskFlowSelectionOverlay> createState() =>
      _AskFlowSelectionOverlayState();
}

class _AskFlowSelectionOverlayState extends State<AskFlowSelectionOverlay> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<AskFlowsBloc>();
    if (bloc.state.status == AskFlowsStatus.initial ||
        bloc.state.flows.isEmpty) {
      bloc.add(const AskFlowsFetchRequested());
    }
  }

  static const List<Map<String, dynamic>> _defaultFlows = [
    {
      'code': 'collaboration',
      'name': 'Find a Collaboration',
      'desc': 'A partner, co-founder, JV, vendor — someone to work with',
      'icon': Icons.hub_rounded,
      'bgGradient': [Color(0xFF1D4ED8), Color(0xFFE11D48)],
    },
    {
      'code': 'referral',
      'name': 'Request a Referral',
      'desc': 'An introduction to one specific person or company',
      'icon': Icons.person_pin_circle_rounded,
      'bgGradient': [Color(0xFF1E40AF), Color(0xFF1D4ED8)],
    },
    {
      'code': 'help',
      'name': 'Get Help & Advice',
      'desc':
          'Advice, mentorship, a small task, capital guidance, or someone to talk to',
      'icon': Icons.help_outline_rounded,
      'bgGradient': [Color(0xFF0F172A), Color(0xFF334155)],
    },
  ];

  void _onSelect(AskFlowEntity flow) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(AppRoutes.askTypes, arguments: flow);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return Scaffold(
      backgroundColor: isDark
          ? AppColor.darkBackground
          : AppColor.lightScaffoldBg,
      body: AppGradientBackground(
        child: SafeArea(
          child: ResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Header Bar with Close Button ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 10,
                      //     vertical: 4,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: isDark
                      //         ? AppColor.darkSurfaceSubtle
                      //         : AppColor.badgeBlueBg,
                      //     borderRadius: BorderRadius.circular(20),
                      //     border: Border.all(
                      //       color: isDark
                      //           ? AppColor.darkBorder
                      //           : AppColor.primaryBlue.withValues(alpha: 0.2),
                      //     ),
                      //   ),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Icon(
                      //         Icons.bolt_rounded,
                      //         size: 14,
                      //         color: isDark
                      //             ? AppColor.warning
                      //             : AppColor.primaryBlue,
                      //       ),
                      //       const SizedBox(width: 4),
                      //       Text(
                      //         'Peers Global',
                      //         style: TextStyle(
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.w600,
                      //           color: isDark
                      //               ? AppColor.darkTextPrimary
                      //               : AppColor.primaryBlue,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColor.darkSurfaceSubtle
                                : AppColor.lightSurfaceSubtle,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? AppColor.darkBorder
                                  : AppColor.lightBorder,
                            ),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: isDark
                                ? AppColor.darkTextPrimary
                                : AppColor.lightTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Heading & Prompt ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What do you need right now?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Choose an option below to reach and connect with matching peers across the community.',
                        style: TextStyle(
                          fontSize: 12,
                          color: subtitleColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── 3 Flow Cards ──
                Expanded(
                  child: BlocBuilder<AskFlowsBloc, AskFlowsState>(
                    builder: (context, state) {
                      if (state.status == AskFlowsStatus.loading &&
                          state.flows.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }

                      if (state.status == AskFlowsStatus.error &&
                          state.flows.isEmpty) {
                        return AppErrorView(
                          title: 'Unable to Load Options',
                          message:
                              state.errorMessage ??
                              'Please check your connection and try again.',
                          onRetry: () => context.read<AskFlowsBloc>().add(
                            const AskFlowsFetchRequested(),
                          ),
                        );
                      }

                      final activeFlows = state.flows
                          .where((f) => f.isActive)
                          .toList();

                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        children: [
                          if (activeFlows.isNotEmpty)
                            ...activeFlows.asMap().entries.map((entry) {
                              final index = entry.key;
                              final flow = entry.value;
                              final meta = _defaultFlows.firstWhere(
                                (m) =>
                                    m['code'] == flow.code.toLowerCase().trim(),
                                orElse: () =>
                                    _defaultFlows[index % _defaultFlows.length],
                              );
                              return _buildFlowCard(
                                flow: flow,
                                title: flow.name,
                                desc: flow.description.isNotEmpty
                                    ? flow.description
                                    : (meta['desc'] as String),
                                icon: meta['icon'] as IconData,
                                bgGradient: meta['bgGradient'] as List<Color>,
                              );
                            })
                          else
                            ..._defaultFlows.map((meta) {
                              final flow = AskFlowEntity(
                                id: meta['code'] as String,
                                code: meta['code'] as String,
                                name: meta['name'] as String,
                                description: meta['desc'] as String,
                                isActive: true,
                                sortOrder: 0,
                              );
                              return _buildFlowCard(
                                flow: flow,
                                title: meta['name'] as String,
                                desc: meta['desc'] as String,
                                icon: meta['icon'] as IconData,
                                bgGradient: meta['bgGradient'] as List<Color>,
                              );
                            }),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlowCard({
    required AskFlowEntity flow,
    required String title,
    required String desc,
    required IconData icon,
    required List<Color> bgGradient,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: bgGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bgGradient.first.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _onSelect(flow),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        desc,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.88),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
