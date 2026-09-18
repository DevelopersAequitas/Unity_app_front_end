import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';

abstract class ScheduleP2pMeetingEvent extends Equatable {
  const ScheduleP2pMeetingEvent();

  @override
  List<Object?> get props => [];
}

class ScheduleP2pMeetingPeerSelected extends ScheduleP2pMeetingEvent {
  final PeerEntity? peer;
  const ScheduleP2pMeetingPeerSelected(this.peer);

  @override
  List<Object?> get props => [peer];
}

class ScheduleP2pMeetingDateTimeChanged extends ScheduleP2pMeetingEvent {
  final String dateTime; // YYYY-MM-DD HH:mm:ss
  const ScheduleP2pMeetingDateTimeChanged(this.dateTime);

  @override
  List<Object?> get props => [dateTime];
}

class ScheduleP2pMeetingPlaceChanged extends ScheduleP2pMeetingEvent {
  final String place;
  const ScheduleP2pMeetingPlaceChanged(this.place);

  @override
  List<Object?> get props => [place];
}

class ScheduleP2pMeetingMessageChanged extends ScheduleP2pMeetingEvent {
  final String message;
  const ScheduleP2pMeetingMessageChanged(this.message);

  @override
  List<Object?> get props => [message];
}

class ScheduleP2pMeetingSubmitted extends ScheduleP2pMeetingEvent {
  const ScheduleP2pMeetingSubmitted();
}
