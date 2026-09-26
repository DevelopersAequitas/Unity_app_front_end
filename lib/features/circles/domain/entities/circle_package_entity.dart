import 'package:equatable/equatable.dart';

class CirclePackageEntity extends Equatable {
  final String circleId;
  final String circleName;
  final String? addonCode;
  final String? addonName;
  final double amount;
  final String currency;
  final int durationMonths;
  final bool joinable;

  const CirclePackageEntity({
    required this.circleId,
    required this.circleName,
    this.addonCode,
    this.addonName,
    required this.amount,
    this.currency = 'INR',
    this.durationMonths = 12,
    this.joinable = true,
  });

  @override
  List<Object?> get props => [
        circleId,
        circleName,
        addonCode,
        addonName,
        amount,
        currency,
        durationMonths,
        joinable,
      ];
}
