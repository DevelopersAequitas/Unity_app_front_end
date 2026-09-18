class PartnerWithUsEntity {
  final String? id;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String emailId;
  final String city;
  final String brandOrCompanyName;
  final String websiteOrSocialMediaLink;
  final String industry;
  final String aboutYourBusiness;
  final String partnershipGoal;
  final String whyPartnerWithPeersGlobal;
  final String? status;
  final DateTime? createdAt;

  const PartnerWithUsEntity({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.emailId,
    required this.city,
    required this.brandOrCompanyName,
    required this.websiteOrSocialMediaLink,
    required this.industry,
    required this.aboutYourBusiness,
    required this.partnershipGoal,
    required this.whyPartnerWithPeersGlobal,
    this.status,
    this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();
}
