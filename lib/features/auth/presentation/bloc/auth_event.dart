import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthRequestOtpSubmitted extends AuthEvent {
  final String identifier;
  final String channel;

  const AuthRequestOtpSubmitted(
    this.identifier, {
    this.channel = 'email',
  });

  String get email => identifier;

  @override
  List<Object?> get props => [identifier, channel];
}

class AuthVerifyOtpSubmitted extends AuthEvent {
  final String identifier;
  final String channel;
  final String otp;
  final String deviceName;

  const AuthVerifyOtpSubmitted({
    required this.identifier,
    this.channel = 'email',
    required this.otp,
    this.deviceName = 'Mobile Device',
  });

  String get email => identifier;

  @override
  List<Object?> get props => [identifier, channel, otp, deviceName];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthResetState extends AuthEvent {
  const AuthResetState();
}
