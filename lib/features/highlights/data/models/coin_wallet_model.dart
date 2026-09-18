import '../../domain/entities/coin_wallet_entity.dart';

class CoinTransactionModel {
  final String id;
  final String title;
  final String description;
  final int amount;
  final String type;
  final String date;

  const CoinTransactionModel({
    required this.id,
    required this.title,
    this.description = '',
    this.amount = 0,
    this.type = 'earned',
    this.date = '',
  });

  factory CoinTransactionModel.fromJson(Map<String, dynamic> json) {
    final delta = (json['coins_delta'] ?? json['amount'] ?? json['coins'] ?? 0) as int;
    final tType = delta >= 0 ? 'earned' : 'spent';
    final tTitle = json['reason_label']?.toString() ??
        json['activity_title']?.toString() ??
        json['title']?.toString() ??
        'Coin Transaction';

    return CoinTransactionModel(
      id: json['id']?.toString() ?? '',
      title: tTitle,
      description: json['description']?.toString() ?? json['activity_type']?.toString() ?? '',
      amount: delta.abs(),
      type: tType,
      date: json['created_at']?.toString() ?? json['date']?.toString() ?? '',
    );
  }

  CoinTransactionEntity toEntity() {
    return CoinTransactionEntity(
      id: id,
      title: title,
      description: description,
      amount: amount,
      type: type,
      date: date,
    );
  }
}

class BadgeMilestoneModel {
  final String id;
  final String name;
  final String description;
  final int currentLevel;
  final int targetLevel;
  final bool isUnlocked;

  const BadgeMilestoneModel({
    required this.id,
    required this.name,
    this.description = '',
    this.currentLevel = 0,
    this.targetLevel = 10,
    this.isUnlocked = false,
  });

  factory BadgeMilestoneModel.fromJson(Map<String, dynamic> json) {
    return BadgeMilestoneModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['badge_name']?.toString() ?? 'Milestone Badge',
      description: json['description']?.toString() ?? '',
      currentLevel: (json['current_level'] ?? json['progress'] ?? 0) as int,
      targetLevel: (json['target_level'] ?? json['target'] ?? 10) as int,
      isUnlocked: (json['is_unlocked'] ?? json['unlocked'] ?? false) as bool,
    );
  }

  BadgeMilestoneEntity toEntity() {
    return BadgeMilestoneEntity(
      id: id,
      name: name,
      description: description,
      currentLevel: currentLevel,
      targetLevel: targetLevel,
      isUnlocked: isUnlocked,
    );
  }
}

class CoinWalletModel {
  final int balance;
  final List<CoinTransactionModel> transactions;
  final List<BadgeMilestoneModel> badges;

  const CoinWalletModel({
    this.balance = 0,
    this.transactions = const [],
    this.badges = const [],
  });

  CoinWalletEntity toEntity() {
    return CoinWalletEntity(
      balance: balance,
      transactions: transactions.map((t) => t.toEntity()).toList(),
      badges: badges.map((b) => b.toEntity()).toList(),
    );
  }
}
