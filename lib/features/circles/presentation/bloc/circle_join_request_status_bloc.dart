import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/circle_join_request_entity.dart';
import '../../domain/usecases/cancel_circle_join_request_usecase.dart';
import '../../domain/usecases/get_circle_join_request_status_usecase.dart';
import '../../domain/usecases/get_my_join_requests_usecase.dart';
import 'circle_join_request_status_event.dart';
import 'circle_join_request_status_state.dart';

class CircleJoinRequestStatusBloc
    extends Bloc<CircleJoinRequestStatusEvent, CircleJoinRequestStatusState> {
  final GetCircleJoinRequestStatusUseCase getCircleJoinRequestStatusUseCase;
  final GetMyJoinRequestsUseCase getMyJoinRequestsUseCase;
  final CancelCircleJoinRequestUseCase cancelCircleJoinRequestUseCase;

  CircleJoinRequestStatusBloc({
    required this.getCircleJoinRequestStatusUseCase,
    required this.getMyJoinRequestsUseCase,
    required this.cancelCircleJoinRequestUseCase,
  }) : super(const CircleJoinRequestStatusState()) {
    on<CircleJoinRequestStatusFetchRequested>(_onFetchStatus);
    on<CircleJoinRequestCancelRequested>(_onCancelRequest);
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
}
