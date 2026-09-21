import 'package:equatable/equatable.dart';

class RegisterVisitorEntity extends Equatable {
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

  const RegisterVisitorEntity({
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

  @override
  List<Object?> get props => [
        id,
        eventType,
        eventName,
        eventDate,
        visitorFullName,
        visitorMobile,
        visitorEmail,
        howKnown,
        visitorCity,
        visitorBusiness,
        note,
        createdAt,
      ];
}
