import 'package:equatable/equatable.dart';

class CoinTransactionEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final int amount;
  final String type;
  final String date;

  const CoinTransactionEntity({
    required this.id,
    required this.title,
    this.description = '',
    this.amount = 0,
    this.type = 'earned',
    this.date = '',
  });

  @override
  List<Object?> get props => [id, title, description, amount, type, date];
}

class BadgeMilestoneEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final int currentLevel;
  final int targetLevel;
  final bool isUnlocked;

  const BadgeMilestoneEntity({
    required this.id,
    required this.name,
    this.description = '',
    this.currentLevel = 0,
    this.targetLevel = 10,
    this.isUnlocked = false,
  });

  double get progress => targetLevel > 0 ? (currentLevel / targetLevel).clamp(0.0, 1.0) : 0.0;

  @override
  List<Object?> get props => [id, name, description, currentLevel, targetLevel, isUnlocked];
}

class CoinWalletEntity extends Equatable {
  final int balance;
  final List<CoinTransactionEntity> transactions;
  final List<BadgeMilestoneEntity> badges;

  const CoinWalletEntity({
    this.balance = 0,
    this.transactions = const [],
    this.badges = const [],
  });

  @override
  List<Object?> get props => [balance, transactions, badges];
}
