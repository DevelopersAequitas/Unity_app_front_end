import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class CoinsEvent extends Equatable {
  const CoinsEvent();

  @override
  List<Object?> get props => [];
}

class FetchCoinsWalletEvent extends CoinsEvent {
  final bool isRefresh;
  const FetchCoinsWalletEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class FetchCoinClaimActivitiesEvent extends CoinsEvent {
  final bool isRefresh;
  const FetchCoinClaimActivitiesEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class FetchCoinClaimsEvent extends CoinsEvent {
  final bool isRefresh;
  final String? status;
  const FetchCoinClaimsEvent({this.isRefresh = false, this.status});

  @override
  List<Object?> get props => [isRefresh, status];
}

class SubmitCoinClaimEvent extends CoinsEvent {
  final String activityCode;
  final Map<String, dynamic> fields;
  final File? proofFile;

  const SubmitCoinClaimEvent({
    required this.activityCode,
    required this.fields,
    this.proofFile,
  });

  @override
  List<Object?> get props => [activityCode, fields, proofFile];
}

class ResetCoinClaimStatusEvent extends CoinsEvent {
  const ResetCoinClaimStatusEvent();
}
