import 'package:equatable/equatable.dart';

class ReferralStatusEntity extends Equatable {
  final int id;
  final String name;

  const ReferralStatusEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
