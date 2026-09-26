import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/usecases/cancel_circle_join_request_usecase.dart';
import '../../domain/usecases/get_circle_checkout_url_usecase.dart';
import '../../domain/usecases/get_circle_join_request_status_usecase.dart';
import '../../domain/usecases/get_my_join_requests_usecase.dart';
import '../../domain/usecases/mark_circle_join_request_paid_usecase.dart';
import '../bloc/circle_join_request_status_bloc.dart';
import '../bloc/circle_join_request_status_event.dart';
import '../bloc/circle_join_request_status_state.dart';
import '../bloc/circles_bloc.dart';
import '../bloc/circles_event.dart';
import '../widgets/status/join_request_cancel_button.dart';
import '../widgets/status/join_request_payment_card.dart';
import '../widgets/status/join_request_status_header.dart';
import '../widgets/status/join_request_timeline.dart';

class JoinRequestStatusScreen extends StatelessWidget {
  final String requestId;
  final String circleName;

  const JoinRequestStatusScreen({
    super.key,
    required this.requestId,
    required this.circleName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CircleJoinRequestStatusBloc(
            getCircleJoinRequestStatusUseCase: context
                .read<GetCircleJoinRequestStatusUseCase>(),
            getMyJoinRequestsUseCase: context.read<GetMyJoinRequestsUseCase>(),
            cancelCircleJoinRequestUseCase: context
                .read<CancelCircleJoinRequestUseCase>(),
            getCircleCheckoutUrlUseCase: context
                .read<GetCircleCheckoutUrlUseCase>(),
            markCircleJoinRequestPaidUseCase: context
                .read<MarkCircleJoinRequestPaidUseCase>(),
          )..add(
            CircleJoinRequestStatusFetchRequested(
              requestId: requestId,
              circleName: circleName,
            ),
          ),
      child: _JoinRequestStatusView(
        requestId: requestId,
        circleName: circleName,
      ),
    );
  }
}

class _JoinRequestStatusView extends StatefulWidget {
  final String requestId;
  final String circleName;

  const _JoinRequestStatusView({
    required this.requestId,
    required this.circleName,
  });

  @override
  State<_JoinRequestStatusView> createState() => _JoinRequestStatusViewState();
}

class _JoinRequestStatusViewState extends State<_JoinRequestStatusView>
    with WidgetsBindingObserver {
  Timer? _realtimeTimer;
  bool _isPaymentInProgress = false;
  bool _isCheckingStatus = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startRealtimePolling();
  }

  void _startRealtimePolling() {
    _realtimeTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      if (_isPaymentInProgress) {
        context.read<CircleJoinRequestStatusBloc>().add(
          CircleJoinRequestMarkPaidRequested(
            requestId: widget.requestId,
            circleName: widget.circleName,
            silent: true,
          ),
        );
      } else {
        context.read<CircleJoinRequestStatusBloc>().add(
          CircleJoinRequestStatusFetchRequested(
            requestId: widget.requestId,
            circleName: widget.circleName,
            silent: true,
          ),
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.resumed) {
      if (mounted) {
        if (_isPaymentInProgress) {
          context.read<CircleJoinRequestStatusBloc>().add(
            CircleJoinRequestMarkPaidRequested(
              requestId: widget.requestId,
              circleName: widget.circleName,
              silent: false,
              forceMarkPaid: true, // user just returned from payment browser
            ),
          );
        } else {
          context.read<CircleJoinRequestStatusBloc>().add(
            CircleJoinRequestStatusFetchRequested(
              requestId: widget.requestId,
              circleName: widget.circleName,
              silent: false,
            ),
          );
        }
        context.read<CirclesBloc>().add(const CirclesRefreshRequested());
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _realtimeTimer?.cancel();
    super.dispose();
  }

  Future<void> _launchPaymentUrl(String url) async {
    _isPaymentInProgress = true;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        AppSnackBar.showError(context, 'Could not open payment link');
      }
    }
  }

  void _handlePaymentTap(CircleJoinRequestStatusState state) {
    final req = state.request;
    if (req == null) return;
    _isPaymentInProgress = true;
    context.read<CircleJoinRequestStatusBloc>().add(
      CircleJoinRequestPayRequested(
        circleId: req.circleId,
        paymentUrl: req.paymentUrl,
      ),
    );
  }

  void _handleCheckStatusTap() {
    setState(() => _isCheckingStatus = true);
    context.read<CircleJoinRequestStatusBloc>().add(
      CircleJoinRequestMarkPaidRequested(
        requestId: widget.requestId,
        circleName: widget.circleName,
        silent: false,
      ),
    );
    context.read<CirclesBloc>().add(const CirclesRefreshRequested());
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isCheckingStatus = false);
    });
  }

  void _handleCancel(String requestId) {
    _realtimeTimer?.cancel();
    context.read<CircleJoinRequestStatusBloc>().add(
      CircleJoinRequestCancelRequested(requestId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      CircleJoinRequestStatusBloc,
      CircleJoinRequestStatusState
    >(
      listenWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.paymentLaunchUrl != curr.paymentLaunchUrl ||
          prev.errorMessage != curr.errorMessage ||
          prev.request?.status != curr.request?.status,
      listener: (context, state) {
        if (state.status == CircleJoinRequestStatusStateStatus.cancelled) {
          _realtimeTimer?.cancel();
          AppSnackBar.showSuccess(
            context,
            'Join request cancelled successfully',
          );
          context.read<CirclesBloc>().add(const CirclesRefreshRequested());
          Navigator.of(context).pop();
        } else if (state.paymentLaunchUrl != null &&
            state.paymentLaunchUrl!.isNotEmpty) {
          final url = state.paymentLaunchUrl!;
          context.read<CircleJoinRequestStatusBloc>().add(
            const CircleJoinRequestClearPaymentLaunchUrl(),
          );
          _launchPaymentUrl(url);
        } else if (state.status == CircleJoinRequestStatusStateStatus.error &&
            state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }

        if (state.request?.isPaid == true || state.request?.isMember == true) {
          _isPaymentInProgress = false;
          context.read<CirclesBloc>().add(const CirclesRefreshRequested());
        }
      },
      builder: (context, state) {
        final isLoading =
            state.status == CircleJoinRequestStatusStateStatus.loading &&
            state.request == null;
        final isCancelling =
            state.status == CircleJoinRequestStatusStateStatus.cancelling;

        return Scaffold(
          backgroundColor: AppColor.transparent,
          appBar: AppCommonBar(
            title: widget.circleName,
            showBack: true,
            showSearch: false,
            showNotifications: false,
            showProfile: false,
            onBackTap: () => Navigator.of(context).pop(),
          ),
          body: AppGradientBackground(
            child: ResponsiveContainer(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primaryBlue,
                      ),
                    )
                  : RefreshIndicator(
                      color: AppColor.primaryBlue,
                      onRefresh: () async {
                        context.read<CircleJoinRequestStatusBloc>().add(
                          CircleJoinRequestStatusFetchRequested(
                            requestId: widget.requestId,
                            circleName: widget.circleName,
                          ),
                        );
                        context.read<CirclesBloc>().add(
                          const CirclesRefreshRequested(),
                        );
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            JoinRequestStatusHeader(
                              request: state.request,
                              circleName: widget.circleName,
                            ),
                            const SizedBox(height: 12),
                            JoinRequestTimeline(request: state.request),
                            if (state.request != null) ...[
                              const SizedBox(height: 12),
                              JoinRequestPaymentCard(
                                request: state.request!,
                                isPaying: state.isGeneratingCheckout,
                                isCheckingStatus: _isCheckingStatus,
                                onPayTap: () => _handlePaymentTap(state),
                                onCheckStatusTap: _handleCheckStatusTap,
                              ),
                              if (!state.request!.isMember &&
                                  !state.request!.isPaid)
                                JoinRequestCancelButton(
                                  request: state.request,
                                  isCancelling: isCancelling,
                                  onCancel: () =>
                                      _handleCancel(state.request!.id),
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
