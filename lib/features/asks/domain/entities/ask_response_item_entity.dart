import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';

class AskResponseItemEntity extends Equatable {
  final String id;
  final String askId;
  final String responseType; // 'can_help_directly', 'know_someone', 'introduce_peer', 'not_relevant'
  final String message;
  final String timeline;
  final String? status;
  final String? createdAt;
  final PeerEntity? responder;

  // For 'know_someone' (External Contact Referral)
  final String? contactName;
  final String? contactCompany;
  final String? contactDesignation;
  final String? contactPhone;
  final String? contactAlternatePhone;
  final String? contactEmail;
  final String? contactNote;

  // For 'introduce_peer' (Platform Peer Introduction)
  final PeerEntity? introducedPeer;
  final String? introducedPeerId;
  final String? introducedPeerName;
  final String? introducedPeerCompany;
  final String? introducedPeerAvatar;
  final String? introductionNote;

  final Map<String, dynamic>? rawData;

  const AskResponseItemEntity({
    required this.id,
    required this.askId,
    required this.responseType,
    this.message = '',
    this.timeline = '',
    this.status,
    this.createdAt,
    this.responder,
    this.contactName,
    this.contactCompany,
    this.contactDesignation,
    this.contactPhone,
    this.contactAlternatePhone,
    this.contactEmail,
    this.contactNote,
    this.introducedPeer,
    this.introducedPeerId,
    this.introducedPeerName,
    this.introducedPeerCompany,
    this.introducedPeerAvatar,
    this.introductionNote,
    this.rawData,
  });

  bool get isDirectHelp =>
      responseType == 'can_help_directly' || responseType == 'direct_help';

  bool get isContactReferral =>
      responseType == 'know_someone' ||
      responseType == 'contact_referral' ||
      responseType == 'refer_contact';

  bool get isPeerIntro =>
      responseType == 'introduce_peer' ||
      responseType == 'can_introduce_peer' ||
      responseType == 'peer_intro';

  @override
  List<Object?> get props => [
        id,
        askId,
        responseType,
        message,
        timeline,
        status,
        createdAt,
        responder,
        contactName,
        contactCompany,
        contactDesignation,
        contactPhone,
        contactAlternatePhone,
        contactEmail,
        contactNote,
        introducedPeer,
        introducedPeerId,
        introducedPeerName,
        introductionNote,
      ];
}
