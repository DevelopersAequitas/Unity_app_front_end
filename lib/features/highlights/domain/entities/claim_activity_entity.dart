import 'package:equatable/equatable.dart';

class ClaimActivityFieldEntity extends Equatable {
  final String key;
  final String label;
  final String type;
  final bool required;
  final String? placeholder;

  const ClaimActivityFieldEntity({
    required this.key,
    required this.label,
    this.type = 'text',
    this.required = true,
    this.placeholder,
  });

  @override
  List<Object?> get props => [key, label, type, required, placeholder];
}

class ClaimActivityEntity extends Equatable {
  final String code;
  final String label;
  final int coins;
  final String description;
  final List<ClaimActivityFieldEntity> fields;

  const ClaimActivityEntity({
    required this.code,
    required this.label,
    this.coins = 0,
    this.description = '',
    this.fields = const [],
  });

  @override
  List<Object?> get props => [code, label, coins, description, fields];
}
