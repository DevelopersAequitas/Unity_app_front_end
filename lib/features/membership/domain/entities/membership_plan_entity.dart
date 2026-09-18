import 'package:equatable/equatable.dart';

class MembershipPlanEntity extends Equatable {
  final String planCode;
  final String name;
  final double price;
  final String currency;
  final String interval;
  final int intervalCount;
  final String status;
  final String description;
  final String tier;
  final bool isPopular;
  final List<String> features;

  const MembershipPlanEntity({
    required this.planCode,
    required this.name,
    required this.price,
    this.currency = 'INR',
    required this.interval,
    this.intervalCount = 1,
    required this.status,
    required this.description,
    required this.tier,
    this.isPopular = false,
    this.features = const [],
  });

  String get durationLabel {
    final lower = name.toLowerCase();
    if (lower.contains('month') || planCode == '012') return '/ month';
    if (lower.contains('2-year') ||
        lower.contains('2 year') ||
        planCode == '014') {
      return '/ 2 years';
    }
    if (lower.contains('year') || planCode == '013') return '/ year';
    return '/ year';
  }

  String get displayTitle {
    final lower = name.toLowerCase();
    if (lower.contains('1-month') ||
        lower.contains('1 month') ||
        planCode == '012') {
      return '1 Month';
    }
    if (lower.contains('1-year') ||
        lower.contains('1 year') ||
        planCode == '013') {
      return '1 Year';
    }
    if (lower.contains('2-year') ||
        lower.contains('2 year') ||
        planCode == '014') {
      return '2 Year';
    }
    return name.trim();
  }

  String get displayTier {
    if (description.isNotEmpty) {
      if (description.contains('(')) {
        return description.split('(').first.trim();
      }
      return description.trim();
    }
    if (tier.isNotEmpty) return tier;
    if (planCode == '012') return 'Starter';
    if (planCode == '013') return 'Builder';
    if (planCode == '014') return 'Leader';
    return 'Pro';
  }

  String? get badgeLabel {
    if (description.contains('(') && description.contains(')')) {
      final inside = description
          .substring(description.indexOf('(') + 1, description.indexOf(')'))
          .trim();
      if (inside.toLowerCase().contains('popul')) return 'Most Popular';
      if (inside.toLowerCase().contains('value')) return 'Best Value';
      return inside;
    }
    if (isPopular || planCode == '013') return 'Most Popular';
    if (planCode == '014') return 'Best Value';
    return null;
  }

  List<String> get resolvedFeatures {
    if (features.isNotEmpty) return features;
    if (planCode == '012') {
      return [
        'Full Pro membership access',
        'Join circles & discussions',
        'Peer messaging & network',
        'Standard event access',
      ];
    } else if (planCode == '013') {
      return [
        'All Starter features',
        'Save 58% vs monthly',
        'Priority peer introductions',
        'Exclusive circle access',
      ];
    } else if (planCode == '014') {
      return [
        'All Builder features',
        'Maximum long-term value',
        'Featured profile badge',
        'VIP community recognition',
      ];
    }
    return [
      'Full Pro membership access',
      'Unlimited peer connections',
      'Exclusive circle participation',
      'Online & offline events',
    ];
  }

  @override
  List<Object?> get props => [
    planCode,
    name,
    price,
    currency,
    interval,
    intervalCount,
    status,
    description,
    tier,
    isPopular,
    features,
  ];
}
