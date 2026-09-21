import '../../domain/entities/register_visitor_entity.dart';

class RegisterVisitorModel {
  final String id;
  final String eventType;
  final String eventName;
  final String eventDate;
  final String visitorFullName;
  final String visitorMobile;
  final String visitorEmail;
  final String howKnown;
  final String visitorCity;
  final String visitorBusiness;
  final String note;
  final String createdAt;

  const RegisterVisitorModel({
    this.id = '',
    this.eventType = 'physical',
    required this.eventName,
    required this.eventDate,
    required this.visitorFullName,
    required this.visitorMobile,
    this.visitorEmail = '',
    this.howKnown = 'friend',
    this.visitorCity = '',
    this.visitorBusiness = '',
    this.note = '',
    this.createdAt = '',
  });

  factory RegisterVisitorModel.fromJson(Map<String, dynamic> json) {
    return RegisterVisitorModel(
      id: json['id']?.toString() ?? '',
      eventType: json['event_type']?.toString() ?? 'physical',
      eventName: json['event_name']?.toString() ?? '',
      eventDate: json['event_date']?.toString() ?? '',
      visitorFullName: json['visitor_full_name']?.toString() ?? '',
      visitorMobile: json['visitor_mobile']?.toString() ?? '',
      visitorEmail: json['visitor_email']?.toString() ?? '',
      howKnown: json['how_known']?.toString() ?? 'friend',
      visitorCity: json['visitor_city']?.toString() ?? '',
      visitorBusiness: json['visitor_business']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? json['submitted_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'event_type': eventType,
      'event_name': eventName,
      'event_date': eventDate,
      'visitor_full_name': visitorFullName,
      'visitor_mobile': visitorMobile,
      'visitor_city': visitorCity,
      'visitor_business': visitorBusiness,
      'visitor_email': visitorEmail,
      'how_known': howKnown,
    };
    if (note.isNotEmpty) map['note'] = note;
    return map;
  }

  RegisterVisitorEntity toEntity() {
    return RegisterVisitorEntity(
      id: id,
      eventType: eventType,
      eventName: eventName,
      eventDate: eventDate,
      visitorFullName: visitorFullName,
      visitorMobile: visitorMobile,
      visitorEmail: visitorEmail,
      howKnown: howKnown,
      visitorCity: visitorCity,
      visitorBusiness: visitorBusiness,
      note: note,
      createdAt: createdAt,
    );
  }

  factory RegisterVisitorModel.fromEntity(RegisterVisitorEntity entity) {
    return RegisterVisitorModel(
      id: entity.id,
      eventType: entity.eventType,
      eventName: entity.eventName,
      eventDate: entity.eventDate,
      visitorFullName: entity.visitorFullName,
      visitorMobile: entity.visitorMobile,
      visitorEmail: entity.visitorEmail,
      howKnown: entity.howKnown,
      visitorCity: entity.visitorCity,
      visitorBusiness: entity.visitorBusiness,
      note: entity.note,
      createdAt: entity.createdAt,
    );
  }
}
