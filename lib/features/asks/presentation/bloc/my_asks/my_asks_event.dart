import 'package:equatable/equatable.dart';

abstract class MyAsksEvent extends Equatable {
  const MyAsksEvent();

  @override
  List<Object?> get props => [];
}

class MyAsksFetchRequested extends MyAsksEvent {
  final String? flow;
  final String? status;
  final bool refresh;

  const MyAsksFetchRequested({
    this.flow,
    this.status,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [flow, status, refresh];
}

class UpdateAskStatusRequested extends MyAsksEvent {
  final String askId;
  final String status;
  final int? statusId;
  final String? outcomeStatus;
  final String? approxValue;
  final String? note;
  final bool? shareStory;

  const UpdateAskStatusRequested({
    required this.askId,
    required this.status,
    this.statusId,
    this.outcomeStatus,
    this.approxValue,
    this.note,
    this.shareStory,
  });

  @override
  List<Object?> get props => [
        askId,
        status,
        statusId,
        outcomeStatus,
        approxValue,
        note,
        shareStory,
      ];
}
