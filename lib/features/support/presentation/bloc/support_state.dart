import 'package:equatable/equatable.dart';
import '../../domain/entities/support_ticket_entity.dart';

enum SupportStatus { initial, loading, success, failure }

class SupportState extends Equatable {
  final SupportStatus status;
  final List<SupportTicketEntity> tickets;
  final bool isSubmitting;
  final bool submitSuccess;
  final String? errorMessage;

  const SupportState({
    this.status = SupportStatus.initial,
    this.tickets = const [],
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.errorMessage,
  });

  SupportState copyWith({
    SupportStatus? status,
    List<SupportTicketEntity>? tickets,
    bool? isSubmitting,
    bool? submitSuccess,
    String? errorMessage,
  }) {
    return SupportState(
      status: status ?? this.status,
      tickets: tickets ?? this.tickets,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? this.submitSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        tickets,
        isSubmitting,
        submitSuccess,
        errorMessage,
      ];
}
