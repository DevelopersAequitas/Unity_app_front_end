import '../../../peers/data/models/peer_model.dart';
import '../../domain/entities/ask_response_item_entity.dart';

class AskResponseItemModel {
  final String id;
  final String askId;
  final String responseType;
  final String message;
  final String timeline;
  final String? status;
  final String? createdAt;
  final PeerModel? responder;

  final String? contactName;
  final String? contactCompany;
  final String? contactDesignation;
  final String? contactPhone;
  final String? contactAlternatePhone;
  final String? contactEmail;
  final String? contactNote;

  final PeerModel? introducedPeer;
  final String? introducedPeerId;
  final String? introducedPeerName;
  final String? introducedPeerCompany;
  final String? introducedPeerAvatar;
  final String? introductionNote;

  final Map<String, dynamic> rawData;

  const AskResponseItemModel({
    required this.id,
    required this.askId,
    required this.responseType,
    required this.message,
    required this.timeline,
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
    this.rawData = const {},
  });

  factory AskResponseItemModel.fromJson(Map<String, dynamic> json) {
    final rawType = (json['response_type'] ?? json['type'] ?? 'can_help_directly')
        .toString();

    // Parse Responder
    PeerModel? respModel;
    if (json['responder'] is Map) {
      respModel = PeerModel.fromJson(json['responder'] as Map<String, dynamic>);
    } else if (json['user'] is Map) {
      respModel = PeerModel.fromJson(json['user'] as Map<String, dynamic>);
    } else if (json['actor'] is Map) {
      respModel = PeerModel.fromJson(json['actor'] as Map<String, dynamic>);
    }

    // Parse Contact Info
    final contactMap = json['contact'] is Map
        ? json['contact'] as Map<String, dynamic>
        : (json['extra_data']?['contact'] is Map
            ? json['extra_data']['contact'] as Map<String, dynamic>
            : null);

    final cName = contactMap?['full_name'] ??
        contactMap?['name'] ??
        json['contact_name'];
    final cCompany = contactMap?['company_name'] ??
        contactMap?['company'] ??
        json['contact_company'];
    final cDesignation = contactMap?['designation'] ??
        contactMap?['role'] ??
        contactMap?['title'] ??
        json['contact_designation'];
    final cPhone = contactMap?['phone'] ??
        contactMap?['phone_number'] ??
        contactMap?['mobile'] ??
        json['contact_phone'];
    final cAltPhone = contactMap?['alternate_phone'] ??
        contactMap?['alt_phone'] ??
        json['contact_alternate_phone'];
    final cEmail = contactMap?['email'] ??
        contactMap?['email_address'] ??
        json['contact_email'];
    final cNote = contactMap?['note'] ??
        contactMap?['notes'] ??
        json['contact_note'] ??
        json['message'];

    // Parse Introduced Peer
    PeerModel? introPeerModel;
    if (json['introduced_peer'] is Map) {
      introPeerModel = PeerModel.fromJson(
        json['introduced_peer'] as Map<String, dynamic>,
      );
    } else if (json['introduced_user'] is Map) {
      introPeerModel = PeerModel.fromJson(
        json['introduced_user'] as Map<String, dynamic>,
      );
    }

    final introId = json['introduced_peer_id'] ??
        json['introduced_user_id'] ??
        introPeerModel?.id;
    final introName = json['introduced_peer_name'] ??
        json['introduced_user_name'] ??
        introPeerModel?.displayName;
    final introCompany = json['introduced_peer_company'] ??
        introPeerModel?.companyName;
    final introAvatar = json['introduced_peer_avatar'] ??
        introPeerModel?.profilePhotoUrl;
    final introNote = json['introduction_note'] ??
        json['extra_data']?['note'] ??
        json['note'];

    return AskResponseItemModel(
      id: (json['id'] ?? json['response_id'] ?? '').toString(),
      askId: (json['ask_id'] ?? '').toString(),
      responseType: rawType,
      message: (json['message'] ?? json['body'] ?? '').toString(),
      timeline: (json['timeline'] ?? '').toString(),
      status: json['status']?.toString(),
      createdAt: json['responded_at']?.toString() ??
          json['created_at']?.toString() ??
          json['submitted_at']?.toString(),
      responder: respModel,
      contactName: cName?.toString(),
      contactCompany: cCompany?.toString(),
      contactDesignation: cDesignation?.toString(),
      contactPhone: cPhone?.toString(),
      contactAlternatePhone: cAltPhone?.toString(),
      contactEmail: cEmail?.toString(),
      contactNote: cNote?.toString(),
      introducedPeer: introPeerModel,
      introducedPeerId: introId?.toString(),
      introducedPeerName: introName?.toString(),
      introducedPeerCompany: introCompany?.toString(),
      introducedPeerAvatar: introAvatar?.toString(),
      introductionNote: introNote?.toString(),
      rawData: json,
    );
  }

  AskResponseItemEntity toEntity() {
    return AskResponseItemEntity(
      id: id,
      askId: askId,
      responseType: responseType,
      message: message,
      timeline: timeline,
      status: status,
      createdAt: createdAt,
      responder: responder?.toEntity(),
      contactName: contactName,
      contactCompany: contactCompany,
      contactDesignation: contactDesignation,
      contactPhone: contactPhone,
      contactAlternatePhone: contactAlternatePhone,
      contactEmail: contactEmail,
      contactNote: contactNote,
      introducedPeer: introducedPeer?.toEntity(),
      introducedPeerId: introducedPeerId,
      introducedPeerName: introducedPeerName,
      introducedPeerCompany: introducedPeerCompany,
      introducedPeerAvatar: introducedPeerAvatar,
      introductionNote: introductionNote,
      rawData: rawData,
    );
  }
}
