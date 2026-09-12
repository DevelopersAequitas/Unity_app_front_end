import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../domain/usecases/accept_connection_request_usecase.dart';
import '../../domain/usecases/cancel_sent_connection_request_usecase.dart';
import '../../domain/usecases/decline_connection_request_usecase.dart';
import '../../domain/usecases/get_connection_requests_usecase.dart';
import '../../domain/usecases/get_sent_connection_requests_usecase.dart';
import 'peer_requests_event.dart';
import 'peer_requests_state.dart';

class PeerRequestsBloc extends Bloc<PeerRequestsEvent, PeerRequestsState> {
  final GetConnectionRequestsUseCase getConnectionRequestsUseCase;
  final GetSentConnectionRequestsUseCase getSentConnectionRequestsUseCase;
  final AcceptConnectionRequestUseCase acceptConnectionRequestUseCase;
  final DeclineConnectionRequestUseCase declineConnectionRequestUseCase;
  final CancelSentConnectionRequestUseCase cancelSentConnectionRequestUseCase;
  StreamSubscription<PeerBusEvent>? _busSubscription;

  PeerRequestsBloc({
    required this.getConnectionRequestsUseCase,
    required this.getSentConnectionRequestsUseCase,
    required this.acceptConnectionRequestUseCase,
    required this.declineConnectionRequestUseCase,
    required this.cancelSentConnectionRequestUseCase,
  }) : super(const PeerRequestsState()) {
    on<PeerRequestsFetchRequested>(_onFetch);
    on<PeerRequestsRefreshRequested>(_onRefresh);
    on<PeerRequestsTabChanged>(_onTabChanged);
    on<PeerRequestAcceptRequested>(_onAccept);
    on<PeerRequestDeclineRequested>(_onDecline);
    on<PeerRequestCancelRequested>(_onCancel);

    _busSubscription = PeersEventBus.instance.stream.listen((event) {
      if (event is PeerConnectionRequestedEvent ||
          event is PeerConnectionCancelledEvent ||
          event is PeerConnectionDeclinedEvent ||
          event is PeerConnectionAcceptedEvent ||
          event is PeersSyncNeededEvent) {
        add(const PeerRequestsRefreshRequested());
      }
    });
  }

  @override
  Future<void> close() {
    _busSubscription?.cancel();
    return super.close();
  }

  Future<void> _onFetch(
    PeerRequestsFetchRequested event,
    Emitter<PeerRequestsState> emit,
  ) async {
    emit(state.copyWith(status: PeerRequestsStatus.loading));
    try {
      final received = await getConnectionRequestsUseCase();
      final sent = await getSentConnectionRequestsUseCase();
      emit(state.copyWith(
        status: PeerRequestsStatus.success,
        receivedRequests: received,
        sentRequests: sent,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PeerRequestsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefresh(
    PeerRequestsRefreshRequested event,
    Emitter<PeerRequestsState> emit,
  ) async {
    try {
      final received = await getConnectionRequestsUseCase();
      final sent = await getSentConnectionRequestsUseCase();
      emit(state.copyWith(
        status: PeerRequestsStatus.success,
        receivedRequests: received,
        sentRequests: sent,
      ));
    } catch (_) {}
  }

  void _onTabChanged(
    PeerRequestsTabChanged event,
    Emitter<PeerRequestsState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tabIndex));
  }

  Future<void> _onAccept(
    PeerRequestAcceptRequested event,
    Emitter<PeerRequestsState> emit,
  ) async {
    final matchReq = state.receivedRequests
        .where((r) => r.id == event.requestId)
        .firstOrNull;
    final updated = state.receivedRequests
        .where((r) => r.id != event.requestId)
        .toList();
    emit(state.copyWith(receivedRequests: updated));
    try {
      await acceptConnectionRequestUseCase(event.requesterId);
      PeersEventBus.instance.emit(
        PeerConnectionAcceptedEvent(
          peerId: event.requesterId,
          peer: matchReq?.peer,
        ),
      );
    } catch (_) {}
  }

  Future<void> _onDecline(
    PeerRequestDeclineRequested event,
    Emitter<PeerRequestsState> emit,
  ) async {
    final updated = state.receivedRequests
        .where((r) => r.id != event.requestId)
        .toList();
    emit(state.copyWith(receivedRequests: updated));
    try {
      await declineConnectionRequestUseCase(event.memberId);
      PeersEventBus.instance.emit(
        PeerConnectionDeclinedEvent(peerId: event.memberId),
      );
    } catch (_) {}
  }

  Future<void> _onCancel(
    PeerRequestCancelRequested event,
    Emitter<PeerRequestsState> emit,
  ) async {
    final updated = state.sentRequests
        .where((r) => r.peer.id != event.requestId && r.id != event.requestId)
        .toList();
    emit(state.copyWith(sentRequests: updated));
    try {
      await cancelSentConnectionRequestUseCase(event.requestId);
      PeersEventBus.instance.emit(
        PeerConnectionCancelledEvent(peerId: event.requestId),
      );
    } catch (_) {}
  }
}
