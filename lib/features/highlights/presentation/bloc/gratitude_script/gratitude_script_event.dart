import 'package:equatable/equatable.dart';

abstract class GratitudeScriptEvent extends Equatable {
  const GratitudeScriptEvent();

  @override
  List<Object?> get props => [];
}

class FetchGratitudeScriptEvent extends GratitudeScriptEvent {
  final bool isRefresh;
  const FetchGratitudeScriptEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class SaveGratitudeScriptEvent extends GratitudeScriptEvent {
  final String progressWord;
  final String nextMonthGoal;
  final String experienceStory;

  const SaveGratitudeScriptEvent({
    required this.progressWord,
    required this.nextMonthGoal,
    this.experienceStory = '',
  });

  @override
  List<Object?> get props => [progressWord, nextMonthGoal, experienceStory];
}

