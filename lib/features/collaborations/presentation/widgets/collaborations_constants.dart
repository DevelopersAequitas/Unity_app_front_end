class ScopeOption {
  final String value;
  final String label;

  const ScopeOption({required this.value, required this.label});
}

const List<ScopeOption> scopeOptions = [
  ScopeOption(value: 'same_city', label: 'Same City'),
  ScopeOption(value: 'same_state', label: 'Same State'),
  ScopeOption(value: 'same_country', label: 'Same Country'),
  ScopeOption(value: 'international', label: 'International'),
];

class PreferredModelOption {
  final String value;
  final String label;

  const PreferredModelOption({required this.value, required this.label});
}

const List<PreferredModelOption> preferredModelOptions = [
  PreferredModelOption(value: 'revenue_share', label: 'Revenue Share'),
  PreferredModelOption(value: 'commission_based', label: 'Commission Based'),
  PreferredModelOption(value: 'equity', label: 'Equity'),
  PreferredModelOption(value: 'profit_sharing', label: 'Profit Sharing'),
  PreferredModelOption(value: 'fixed_contract', label: 'Fixed Contract'),
  PreferredModelOption(value: 'open_for_discussion', label: 'Open for Discussion'),
];

class BusinessStageOption {
  final String value;
  final String label;

  const BusinessStageOption({required this.value, required this.label});
}

const List<BusinessStageOption> businessStageOptions = [
  BusinessStageOption(value: 'idea_stage', label: 'Idea Stage'),
  BusinessStageOption(value: 'early_revenue', label: 'Early Revenue'),
  BusinessStageOption(value: 'growing_10l_1cr', label: 'Growing (₹10L–₹1Cr)'),
  BusinessStageOption(value: 'scaling_1cr_10cr', label: 'Scaling (₹1Cr–₹10Cr)'),
  BusinessStageOption(value: 'established_10cr_plus', label: 'Established (₹10Cr+)'),
];

class YearsInOperationOption {
  final String value;
  final String label;

  const YearsInOperationOption({required this.value, required this.label});
}

const List<YearsInOperationOption> yearsInOperationOptions = [
  YearsInOperationOption(value: 'less_than_1_year', label: '<1 Year'),
  YearsInOperationOption(value: '1_3_years', label: '1–3 Years'),
  YearsInOperationOption(value: '3_7_years', label: '3–7 Years'),
  YearsInOperationOption(value: '7_plus_years', label: '7+ Years'),
];

class UrgencyOption {
  final String value;
  final String label;

  const UrgencyOption({required this.value, required this.label});
}

const List<UrgencyOption> urgencyOptions = [
  UrgencyOption(value: 'immediate_30_days', label: 'Immediate (Within 30 days)'),
  UrgencyOption(value: '1_3_months', label: '1–3 Months'),
  UrgencyOption(value: '3_6_months', label: '3–6 Months'),
  UrgencyOption(value: 'exploratory', label: 'Exploratory'),
];
