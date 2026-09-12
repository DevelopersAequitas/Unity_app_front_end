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
  final String email;
  final String channel;

  const AuthRequestOtpSubmitted(this.email, {this.channel = 'email'});

  @override
  List<Object?> get props => [email, channel];
}

class AuthVerifyOtpSubmitted extends AuthEvent {
  final String email;
  final String otp;
  final String deviceName;

  const AuthVerifyOtpSubmitted({
    required this.email,
    required this.otp,
    this.deviceName = 'Mobile Device',
  });

  @override
  List<Object?> get props => [email, otp, deviceName];
}

class AuthResetState extends AuthEvent {
  const AuthResetState();
}
