import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';

abstract class AddP2pMeetingEvent extends Equatable {
  const AddP2pMeetingEvent();

  @override
  List<Object?> get props => [];
}

class AddP2pMeetingPeerSelected extends AddP2pMeetingEvent {
  final PeerEntity? peer;
  const AddP2pMeetingPeerSelected(this.peer);

  @override
  List<Object?> get props => [peer];
}

class AddP2pMeetingDateChanged extends AddP2pMeetingEvent {
  final String date; // YYYY-MM-DD
  const AddP2pMeetingDateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

class AddP2pMeetingPlaceChanged extends AddP2pMeetingEvent {
  final String place;
  const AddP2pMeetingPlaceChanged(this.place);

  @override
  List<Object?> get props => [place];
}

class AddP2pMeetingRemarksChanged extends AddP2pMeetingEvent {
  final String remarks;
  const AddP2pMeetingRemarksChanged(this.remarks);

  @override
  List<Object?> get props => [remarks];
}

class AddP2pMeetingPhotoSelected extends AddP2pMeetingEvent {
  final File? photo;
  const AddP2pMeetingPhotoSelected(this.photo);

  @override
  List<Object?> get props => [photo];
}

class AddP2pMeetingCreativeSelected extends AddP2pMeetingEvent {
  final File? creativeImage;
  const AddP2pMeetingCreativeSelected(this.creativeImage);

  @override
  List<Object?> get props => [creativeImage];
}

class AddP2pMeetingSubmitted extends AddP2pMeetingEvent {
  final File? creativeImage;
  const AddP2pMeetingSubmitted({this.creativeImage});

  @override
  List<Object?> get props => [creativeImage];
}
