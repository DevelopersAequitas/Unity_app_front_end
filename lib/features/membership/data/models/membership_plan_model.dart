import '../../domain/entities/membership_plan_entity.dart';

class MembershipPlanModel extends MembershipPlanEntity {
  const MembershipPlanModel({
    required super.planCode,
    required super.name,
    required super.price,
    super.currency = 'INR',
    required super.interval,
    super.intervalCount = 1,
    required super.status,
    required super.description,
    required super.tier,
    super.isPopular = false,
    super.features = const [],
  });

  factory MembershipPlanModel.fromJson(Map<String, dynamic> json) {
    final code = json['plan_code']?.toString() ?? json['id']?.toString() ?? json['code']?.toString() ?? '012';
    final name = json['name']?.toString() ?? json['plan_name']?.toString() ?? 'Pro Plan';
    final price = double.tryParse(json['price']?.toString() ?? json['amount']?.toString() ?? '0') ?? 0.0;
    final currency = json['currency']?.toString() ?? json['currency_code']?.toString() ?? 'INR';
    final interval = json['interval']?.toString() ?? json['period']?.toString() ?? 'months';
    final intervalCount = int.tryParse(json['interval_count']?.toString() ?? json['interval_unit']?.toString() ?? '1') ?? 1;
    final status = json['status']?.toString() ?? 'active';
    final description = json['description']?.toString() ?? '';

    String tier = json['tier']?.toString() ?? '';
    if (tier.isEmpty) {
      if (description.isNotEmpty) {
        tier = description.contains('(') ? description.split('(').first.trim() : description.trim();
      } else {
        if (code == '012') tier = 'Starter';
        if (code == '013') tier = 'Builder';
        if (code == '014') tier = 'Leader';
      }
    }

    final isPopular = json['is_popular'] == true ||
        json['popular'] == true ||
        description.toLowerCase().contains('popul') ||
        code == '013';

    List<String> features = [];
    if (json['features'] is List) {
      features = (json['features'] as List).map((e) => e.toString()).toList();
    }

    return MembershipPlanModel(
      planCode: code,
      name: name,
      price: price,
      currency: currency,
      interval: interval,
      intervalCount: intervalCount,
      status: status,
      description: description,
      tier: tier,
      isPopular: isPopular,
      features: features,
    );
  }

  static List<MembershipPlanModel> get fallbackPlans => const [
        MembershipPlanModel(
          planCode: '012',
          name: '1-Month Subscription – Unity Peer Only ',
          price: 3600,
          currency: 'INR',
          interval: '1',
          intervalCount: 1,
          status: 'active',
          description: 'Starter',
          tier: 'Starter',
          isPopular: false,
          features: [
            'Full Pro membership access',
            'Join circles & discussions',
            'Peer messaging & network',
            'Standard event access',
          ],
        ),
        MembershipPlanModel(
          planCode: '013',
          name: '1-Year Subscription – Unity Peer Only ',
          price: 18000,
          currency: 'INR',
          interval: '1',
          intervalCount: 1,
          status: 'active',
          description: 'Builder (Most Populer)',
          tier: 'Builder',
          isPopular: true,
          features: [
            'All Starter features',
            'Save 58% vs monthly',
            'Priority peer introductions',
            'Exclusive circle access',
          ],
        ),
        MembershipPlanModel(
          planCode: '014',
          name: '2-Year Subscription – Unity Peer Only',
          price: 25000,
          currency: 'INR',
          interval: '2',
          intervalCount: 2,
          status: 'active',
          description: 'Leader (Best Value)',
          tier: 'Leader',
          isPopular: false,
          features: [
            'All Builder features',
            'Maximum long-term value',
            'Featured profile badge',
            'VIP community recognition',
          ],
        ),
      ];

  Map<String, dynamic> toJson() {
    return {
      'plan_code': planCode,
      'name': name,
      'price': price,
      'currency': currency,
      'interval': interval,
      'status': status,
      'description': description,
      'tier': tier,
      'is_popular': isPopular,
      'features': features,
    };
  }
}
