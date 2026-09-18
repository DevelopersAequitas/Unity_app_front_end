import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';
import '../../domain/entities/p2p_meeting_entity.dart';

enum AddP2pMeetingStatus { initial, submitting, success, failure }

class AddP2pMeetingState extends Equatable {
  final AddP2pMeetingStatus status;
  final PeerEntity? selectedPeer;
  final String meetingDate; // YYYY-MM-DD
  final String meetingPlace;
  final String remarks;
  final File? photoFile;
  final File? creativeImage;
  final String? templateBackgroundUrl;
  final P2pMeetingEntity? createdMeeting;
  final String? errorMessage;

  const AddP2pMeetingState({
    this.status = AddP2pMeetingStatus.initial,
    this.selectedPeer,
    this.meetingDate = '',
    this.meetingPlace = '',
    this.remarks = '',
    this.photoFile,
    this.creativeImage,
    this.templateBackgroundUrl,
    this.createdMeeting,
    this.errorMessage,
  });

  bool get isValid =>
      selectedPeer != null &&
      meetingDate.trim().isNotEmpty &&
      meetingPlace.trim().isNotEmpty &&
      remarks.trim().isNotEmpty;

  AddP2pMeetingState copyWith({
    AddP2pMeetingStatus? status,
    PeerEntity? selectedPeer,
    String? meetingDate,
    String? meetingPlace,
    String? remarks,
    File? photoFile,
    File? creativeImage,
    String? templateBackgroundUrl,
    P2pMeetingEntity? createdMeeting,
    String? errorMessage,
  }) {
    return AddP2pMeetingState(
      status: status ?? this.status,
      selectedPeer: selectedPeer ?? this.selectedPeer,
      meetingDate: meetingDate ?? this.meetingDate,
      meetingPlace: meetingPlace ?? this.meetingPlace,
      remarks: remarks ?? this.remarks,
      photoFile: photoFile ?? this.photoFile,
      creativeImage: creativeImage ?? this.creativeImage,
      templateBackgroundUrl: templateBackgroundUrl ?? this.templateBackgroundUrl,
      createdMeeting: createdMeeting ?? this.createdMeeting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedPeer,
        meetingDate,
        meetingPlace,
        remarks,
        photoFile,
        creativeImage,
        templateBackgroundUrl,
        createdMeeting,
        errorMessage,
      ];
}
