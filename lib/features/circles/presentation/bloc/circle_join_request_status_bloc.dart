import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/circle_join_request_entity.dart';
import '../../domain/usecases/cancel_circle_join_request_usecase.dart';
import '../../domain/usecases/get_circle_checkout_url_usecase.dart';
import '../../domain/usecases/get_circle_join_request_status_usecase.dart';
import '../../domain/usecases/get_my_join_requests_usecase.dart';
import '../../domain/usecases/mark_circle_join_request_paid_usecase.dart';
import 'circle_join_request_status_event.dart';
import 'circle_join_request_status_state.dart';

class CircleJoinRequestStatusBloc
    extends Bloc<CircleJoinRequestStatusEvent, CircleJoinRequestStatusState> {
  final GetCircleJoinRequestStatusUseCase getCircleJoinRequestStatusUseCase;
  final GetMyJoinRequestsUseCase getMyJoinRequestsUseCase;
  final CancelCircleJoinRequestUseCase cancelCircleJoinRequestUseCase;
  final GetCircleCheckoutUrlUseCase? getCircleCheckoutUrlUseCase;
  final MarkCircleJoinRequestPaidUseCase? markCircleJoinRequestPaidUseCase;

  CircleJoinRequestStatusBloc({
    required this.getCircleJoinRequestStatusUseCase,
    required this.getMyJoinRequestsUseCase,
    required this.cancelCircleJoinRequestUseCase,
    this.getCircleCheckoutUrlUseCase,
    this.markCircleJoinRequestPaidUseCase,
  }) : super(const CircleJoinRequestStatusState()) {
    on<CircleJoinRequestStatusFetchRequested>(_onFetchStatus);
    on<CircleJoinRequestCancelRequested>(_onCancelRequest);
    on<CircleJoinRequestPayRequested>(_onPayRequested);
    on<CircleJoinRequestMarkPaidRequested>(_onMarkPaidRequested);
    on<CircleJoinRequestClearPaymentLaunchUrl>(_onClearPaymentLaunchUrl);
  }

  Future<void> _onFetchStatus(
    CircleJoinRequestStatusFetchRequested event,
    Emitter<CircleJoinRequestStatusState> emit,
  ) async {
    if (!event.silent && state.request == null) {
      emit(state.copyWith(status: CircleJoinRequestStatusStateStatus.loading));
    }
    try {
      CircleJoinRequestEntity? req;
      if (event.requestId.isNotEmpty) {
        try {
          req = await getCircleJoinRequestStatusUseCase(event.requestId);
        } catch (_) {}
      }

      if (req == null) {
        try {
          final list = await getMyJoinRequestsUseCase();
          final fromList = list.where((r) {
            return (event.requestId.isNotEmpty && r.id == event.requestId) ||
                (event.circleName.isNotEmpty &&
                    (r.circleName.trim().toLowerCase() == event.circleName.trim().toLowerCase() ||
                        r.categoryName.trim().toLowerCase() == event.circleName.trim().toLowerCase()));
          }).firstOrNull;

          if (fromList != null) {
            req = fromList;
          }
        } catch (_) {}
      }

      if (req != null) {
        emit(state.copyWith(
          status: CircleJoinRequestStatusStateStatus.success,
          request: req,
        ));
      } else if (!event.silent && state.request == null) {
        emit(state.copyWith(
          status: CircleJoinRequestStatusStateStatus.error,
          errorMessage: 'Unable to load request status. Please try again.',
        ));
      }
    } catch (_) {
      if (!event.silent && state.request == null) {
        emit(state.copyWith(
          status: CircleJoinRequestStatusStateStatus.error,
          errorMessage: 'Unable to load request status. Please try again.',
        ));
      }
    }
  }

  Future<void> _onCancelRequest(
    CircleJoinRequestCancelRequested event,
    Emitter<CircleJoinRequestStatusState> emit,
  ) async {
    emit(state.copyWith(status: CircleJoinRequestStatusStateStatus.cancelling));
    try {
      final success = await cancelCircleJoinRequestUseCase(event.requestId);
      if (success) {
        emit(state.copyWith(status: CircleJoinRequestStatusStateStatus.cancelled));
      } else {
        emit(state.copyWith(
          status: CircleJoinRequestStatusStateStatus.error,
          errorMessage: 'Unable to cancel join request. Please try again.',
        ));
      }
    } catch (e) {
      final err = e.toString().toLowerCase();
      if (err.contains('404') ||
          err.contains('not found') ||
          err.contains('already cancelled') ||
          err.contains('success')) {
        // Request already removed or cancelled on server
        emit(state.copyWith(status: CircleJoinRequestStatusStateStatus.cancelled));
        return;
      }
      emit(state.copyWith(
        status: CircleJoinRequestStatusStateStatus.error,
        errorMessage: 'Unable to cancel join request. Please try again.',
      ));
    }
  }

  Future<void> _onPayRequested(
    CircleJoinRequestPayRequested event,
    Emitter<CircleJoinRequestStatusState> emit,
  ) async {
    if (event.paymentUrl != null && event.paymentUrl!.isNotEmpty) {
      emit(state.copyWith(paymentLaunchUrl: event.paymentUrl));
      return;
    }

    if (getCircleCheckoutUrlUseCase != null && event.circleId.isNotEmpty) {
      emit(state.copyWith(isGeneratingCheckout: true));
      try {
        final checkoutUrl = await getCircleCheckoutUrlUseCase!(event.circleId);
        emit(state.copyWith(
          isGeneratingCheckout: false,
          paymentLaunchUrl: checkoutUrl,
        ));
      } catch (e) {
        emit(state.copyWith(
          isGeneratingCheckout: false,
          errorMessage: 'Failed to generate checkout link: ${e.toString().replaceFirst('Exception: ', '')}',
        ));
      }
    }
  }

  void _onClearPaymentLaunchUrl(
    CircleJoinRequestClearPaymentLaunchUrl event,
    Emitter<CircleJoinRequestStatusState> emit,
  ) {
    emit(state.copyWith(clearPaymentLaunchUrl: true));
  }

  Future<void> _onMarkPaidRequested(
    CircleJoinRequestMarkPaidRequested event,
    Emitter<CircleJoinRequestStatusState> emit,
  ) async {
    if (!event.silent && state.request == null) {
      emit(state.copyWith(status: CircleJoinRequestStatusStateStatus.loading));
    }

    CircleJoinRequestEntity? req;

    // Only call mark-paid API when request is actually in pending_circle_fee state
    // OR when caller explicitly forces it (e.g., returning from payment browser)
    final currentStatus = state.request?.status.toLowerCase() ?? '';
    final isInPaymentStage =
        event.forceMarkPaid ||
        currentStatus == 'pending_circle_fee' ||
        (state.request?.canPay == true);

    if (markCircleJoinRequestPaidUseCase != null &&
        event.requestId.isNotEmpty &&
        isInPaymentStage) {
      try {
        req = await markCircleJoinRequestPaidUseCase!(event.requestId);
      } catch (_) {}
    }

    // Always fetch latest real-time status as source of truth
    try {
      final latest = await getCircleJoinRequestStatusUseCase(event.requestId);
      req = latest;
    } catch (_) {}

    if (req != null) {
      emit(state.copyWith(
        status: CircleJoinRequestStatusStateStatus.success,
        request: req,
      ));
    }
  }
}
