import 'package:equatable/equatable.dart';
import '../../../domain/entities/last_month_activity_entity.dart';

enum LastMonthActivityStatus { initial, loading, success, failure }

class LastMonthActivityState extends Equatable {
  final LastMonthActivityStatus status;
  final LastMonthActivityEntity activity;
  final String? errorMessage;

  const LastMonthActivityState({
    this.status = LastMonthActivityStatus.initial,
    this.activity = const LastMonthActivityEntity(),
    this.errorMessage,
  });

  LastMonthActivityState copyWith({
    LastMonthActivityStatus? status,
    LastMonthActivityEntity? activity,
    String? errorMessage,
  }) {
    return LastMonthActivityState(
      status: status ?? this.status,
      activity: activity ?? this.activity,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, activity, errorMessage];
}
