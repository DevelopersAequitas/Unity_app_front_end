class CoinGuidelineItemModel {
  final String id;
  final String activity;
  final int coins;
  final int displayOrder;

  const CoinGuidelineItemModel({
    required this.id,
    required this.activity,
    required this.coins,
    required this.displayOrder,
  });

  factory CoinGuidelineItemModel.fromJson(Map<String, dynamic> json) {
    return CoinGuidelineItemModel(
      id: json['id']?.toString() ?? '',
      activity: json['activity']?.toString() ?? '',
      coins: int.tryParse(json['coins']?.toString() ?? '0') ?? 0,
      displayOrder: int.tryParse(json['display_order']?.toString() ?? '0') ?? 0,
    );
  }
}

class CoinGuidelinesModel {
  final String title;
  final String description;
  final String? icon;
  final List<CoinGuidelineItemModel> guidelines;

  const CoinGuidelinesModel({
    required this.title,
    required this.description,
    this.icon,
    required this.guidelines,
  });

  factory CoinGuidelinesModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final rawList = data['guidelines'] as List<dynamic>? ?? [];
    final list = rawList
        .whereType<Map<String, dynamic>>()
        .map((e) => CoinGuidelineItemModel.fromJson(e))
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return CoinGuidelinesModel(
      title: data['title']?.toString() ?? 'The Coin Reward System',
      description: data['description']?.toString() ??
          'Coins are rewards for being an active community builder. They reflect your engagement and contributions to the network.',
      icon: data['icon']?.toString(),
      guidelines: list,
    );
  }
}
