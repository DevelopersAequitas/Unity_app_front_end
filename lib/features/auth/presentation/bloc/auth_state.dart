import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_token_entity.dart';
import '../../domain/entities/user_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  UserEntity? get user => switch (this) {
        AuthAuthenticated(:final user) => user,
        AuthVerifySuccess(:final user) => user,
        _ => null,
      };

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  final String? message;

  const AuthLoading({this.message});

  @override
  List<Object?> get props => [message];
}

class AuthOtpSentSuccess extends AuthState {
  final String email;
  final String channel;
  final String message;

  const AuthOtpSentSuccess({
    required this.email,
    this.channel = 'email',
    this.message = 'OTP sent successfully.',
  });

  @override
  List<Object?> get props => [email, channel, message];
}

class AuthVerifySuccess extends AuthState {
  @override
  final UserEntity user;
  final AuthTokenEntity token;
  final String message;

  const AuthVerifySuccess({
    required this.user,
    required this.token,
    this.message = 'Login successful',
  });

  @override
  List<Object?> get props => [user, token, message];
}

class AuthAuthenticated extends AuthState {
  @override
  final UserEntity user;
  final AuthTokenEntity token;

  const AuthAuthenticated({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
