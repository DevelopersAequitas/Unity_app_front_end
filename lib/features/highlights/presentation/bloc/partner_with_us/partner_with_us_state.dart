import 'package:equatable/equatable.dart';
import '../../../domain/entities/partner_with_us_entity.dart';

enum PartnerWithUsStatus { initial, loading, submitting, success, error }

class PartnerWithUsState extends Equatable {
  final PartnerWithUsStatus status;
  final List<PartnerWithUsEntity> submissions;
  final String? successMessage;
  final String? errorMessage;

  const PartnerWithUsState({
    this.status = PartnerWithUsStatus.initial,
    this.submissions = const [],
    this.successMessage,
    this.errorMessage,
  });

  PartnerWithUsState copyWith({
    PartnerWithUsStatus? status,
    List<PartnerWithUsEntity>? submissions,
    String? successMessage,
    String? errorMessage,
  }) {
    return PartnerWithUsState(
      status: status ?? this.status,
      submissions: submissions ?? this.submissions,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, submissions, successMessage, errorMessage];
}
