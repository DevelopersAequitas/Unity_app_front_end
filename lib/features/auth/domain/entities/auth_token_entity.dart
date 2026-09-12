import 'package:equatable/equatable.dart';

class AuthTokenEntity extends Equatable {
  final String token;
  final String? tokenType;

  const AuthTokenEntity({required this.token, this.tokenType});

  @override
  List<Object?> get props => [token, tokenType];
}
