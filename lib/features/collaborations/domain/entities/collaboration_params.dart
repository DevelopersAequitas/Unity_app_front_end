class CollaborationParams {
  final String collaborationTypeId;
  final String title;
  final String description;
  final String scope;
  final String industryId;
  final String businessStage;
  final String yearsInOperation;
  final String urgency;
  final List<String>? countriesOfInterest;
  final String? preferredModel;

  const CollaborationParams({
    required this.collaborationTypeId,
    required this.title,
    required this.description,
    required this.scope,
    required this.industryId,
    required this.businessStage,
    required this.yearsInOperation,
    required this.urgency,
    this.countriesOfInterest,
    this.preferredModel,
  });

  Map<String, dynamic> toJson() {
    return {
      'collaboration_type_id': collaborationTypeId,
      'title': title,
      'description': description,
      'scope': scope,
      'industry_id': industryId,
      'business_stage': businessStage,
      'years_in_operation': yearsInOperation,
      'urgency': urgency,
      if (countriesOfInterest != null && countriesOfInterest!.isNotEmpty)
        'countries_of_interest': countriesOfInterest,
      if (preferredModel != null && preferredModel!.isNotEmpty)
        'preferred_model': preferredModel,
    };
  }
}
