import 'dart:async';
import '../../features/peers/domain/entities/peer_entity.dart';

abstract class PeerBusEvent {
  const PeerBusEvent();
}

class PeerConnectionAcceptedEvent extends PeerBusEvent {
  final String peerId;
  final PeerEntity? peer;

  const PeerConnectionAcceptedEvent({required this.peerId, this.peer});
}

class PeerConnectionDeclinedEvent extends PeerBusEvent {
  final String peerId;

  const PeerConnectionDeclinedEvent({required this.peerId});
}

class PeerConnectionRequestedEvent extends PeerBusEvent {
  final String peerId;

  const PeerConnectionRequestedEvent({required this.peerId});
}

class PeerConnectionCancelledEvent extends PeerBusEvent {
  final String peerId;

  const PeerConnectionCancelledEvent({required this.peerId});
}

class PeersSyncNeededEvent extends PeerBusEvent {
  const PeersSyncNeededEvent();
}

class PeersEventBus {
  PeersEventBus._();
  static final PeersEventBus instance = PeersEventBus._();

  final _controller = StreamController<PeerBusEvent>.broadcast();

  Stream<PeerBusEvent> get stream => _controller.stream;

  void emit(PeerBusEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  void dispose() {
    _controller.close();
  }
}
