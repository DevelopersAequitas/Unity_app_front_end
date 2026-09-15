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
import '../../domain/usecases/get_circle_join_request_status_usecase.dart';
import '../../domain/usecases/get_my_join_requests_usecase.dart';
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
      create: (context) => CircleJoinRequestStatusBloc(
        getCircleJoinRequestStatusUseCase:
            context.read<GetCircleJoinRequestStatusUseCase>(),
        getMyJoinRequestsUseCase: context.read<GetMyJoinRequestsUseCase>(),
        cancelCircleJoinRequestUseCase:
            context.read<CancelCircleJoinRequestUseCase>(),
      )..add(CircleJoinRequestStatusFetchRequested(
          requestId: requestId,
          circleName: circleName,
        )),
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

class _JoinRequestStatusViewState extends State<_JoinRequestStatusView> {
  Timer? _realtimeTimer;

  @override
  void initState() {
    super.initState();
    _startRealtimePolling();
  }

  void _startRealtimePolling() {
    _realtimeTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      context.read<CircleJoinRequestStatusBloc>().add(
            CircleJoinRequestStatusFetchRequested(
              requestId: widget.requestId,
              circleName: widget.circleName,
              silent: true,
            ),
          );
    });
  }

  @override
  void dispose() {
    _realtimeTimer?.cancel();
    super.dispose();
  }

  Future<void> _handlePayment(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _handleCancel(String requestId) {
    _realtimeTimer?.cancel();
    context.read<CircleJoinRequestStatusBloc>().add(
          CircleJoinRequestCancelRequested(requestId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CircleJoinRequestStatusBloc, CircleJoinRequestStatusState>(
      listener: (context, state) {
        if (state.status == CircleJoinRequestStatusStateStatus.cancelled) {
          _realtimeTimer?.cancel();
          AppSnackBar.showSuccess(context, 'Join request cancelled successfully');
          context.read<CirclesBloc>().add(const CirclesRefreshRequested());
          Navigator.of(context).pop();
        } else if (state.status == CircleJoinRequestStatusStateStatus.error &&
            state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
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
                                onPayTap: _handlePayment,
                              ),
                              JoinRequestCancelButton(
                                request: state.request,
                                isCancelling: isCancelling,
                                onCancel: () => _handleCancel(state.request!.id),
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
