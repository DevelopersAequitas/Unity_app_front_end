import 'package:equatable/equatable.dart';

abstract class AskResponseEvent extends Equatable {
  const AskResponseEvent();

  @override
  List<Object?> get props => [];
}

class AskResponseSubmitRequested extends AskResponseEvent {
  final String askId;
  final String responseType;
  final String message;
  final String timeline;
  final Map<String, dynamic>? extraData;

  const AskResponseSubmitRequested({
    required this.askId,
    required this.responseType,
    required this.message,
    required this.timeline,
    this.extraData,
  });

  @override
  List<Object?> get props => [askId, responseType, message, timeline, extraData];
}
