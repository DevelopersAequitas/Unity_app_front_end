import 'collaboration_type.dart';
import 'industry.dart';

class Collaboration {
  final String id;
  final CollaborationType collaborationType;
  final String title;
  final String description;
  final String scope;
  final List<String>? countriesOfInterest;
  final String? preferredModel;
  final Industry? industry;
  final String businessStage;
  final String yearsInOperation;
  final String urgency;
  final String status;
  final String completionStatus;
  final String? completedAt;
  final String? acceptedAt;
  final CollaborationAcceptedBy? acceptedBy;
  final String postedAt;
  final double postedDaysAgo;
  final String expiresAt;
  final String memberType;
  final bool isVerified;
  final CollaborationUser user;

  const Collaboration({
    required this.id,
    required this.collaborationType,
    required this.title,
    required this.description,
    required this.scope,
    this.countriesOfInterest,
    this.preferredModel,
    this.industry,
    required this.businessStage,
    required this.yearsInOperation,
    required this.urgency,
    required this.status,
    required this.completionStatus,
    this.completedAt,
    this.acceptedAt,
    this.acceptedBy,
    required this.postedAt,
    required this.postedDaysAgo,
    required this.expiresAt,
    required this.memberType,
    required this.isVerified,
    required this.user,
  });

  bool get isIncomplete => completionStatus.toLowerCase() == 'incomplete' || status.toLowerCase() == 'open';
  bool get isCompleted => completionStatus.toLowerCase() == 'completed' || status.toLowerCase() == 'completed';
}

class CollaborationUser {
  final String id;
  final String name;
  final String city;
  final String? profilePhotoUrl;

  const CollaborationUser({
    required this.id,
    required this.name,
    required this.city,
    this.profilePhotoUrl,
  });
}

class CollaborationAcceptedBy {
  final String id;
  final String name;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? companyName;
  final String? designation;
  final String? city;
  final String? profilePhotoUrl;

  const CollaborationAcceptedBy({
    required this.id,
    required this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.companyName,
    this.designation,
    this.city,
    this.profilePhotoUrl,
  });
}
