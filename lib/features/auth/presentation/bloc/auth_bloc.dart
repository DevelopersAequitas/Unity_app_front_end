import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_error_handler.dart';
import '../../domain/usecases/get_cached_auth_usecase.dart';
import '../../domain/usecases/request_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final GetCachedAuthUseCase getCachedAuthUseCase;

  AuthBloc({
    required this.requestOtpUseCase,
    required this.verifyOtpUseCase,
    required this.getCachedAuthUseCase,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthRequestOtpSubmitted>(_onRequestOtpSubmitted);
    on<AuthVerifyOtpSubmitted>(_onVerifyOtpSubmitted);
    on<AuthResetState>(_onResetState);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final cached = await getCachedAuthUseCase();
      if (cached.user != null && cached.token != null) {
        emit(AuthAuthenticated(user: cached.user!, token: cached.token!));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onRequestOtpSubmitted(
    AuthRequestOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final cleanEmail = event.email.trim();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      emit(const AuthError('Please enter a valid email address.'));
      return;
    }

    emit(const AuthLoading(message: 'Sending OTP...'));
    try {
      await requestOtpUseCase(cleanEmail, channel: event.channel);
      final dest = event.channel == 'whatsapp' ? 'WhatsApp' : 'email';
      emit(
        AuthOtpSentSuccess(
          email: cleanEmail,
          channel: event.channel,
          message: 'OTP sent to your $dest.',
        ),
      );
    } catch (e, stackTrace) {
      final friendlyMsg = AppErrorHandler.toUserFriendlyMessage(e, stackTrace);
      emit(AuthError(friendlyMsg));
    }
  }

  Future<void> _onVerifyOtpSubmitted(
    AuthVerifyOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final cleanOtp = event.otp.trim();
    if (cleanOtp.length < 4) {
      emit(const AuthError('Please enter the 4-digit verification code.'));
      return;
    }

    emit(const AuthLoading(message: 'Verifying code...'));
    try {
      final result = await verifyOtpUseCase(
        email: event.email.trim(),
        otp: cleanOtp,
        deviceName: event.deviceName,
      );
      emit(AuthVerifySuccess(user: result.user, token: result.token));
    } catch (e, stackTrace) {
      final friendlyMsg = AppErrorHandler.toUserFriendlyMessage(e, stackTrace);
      emit(AuthError(friendlyMsg));
    }
  }

  void _onResetState(AuthResetState event, Emitter<AuthState> emit) {
    emit(const AuthInitial());
  }
}
