import 'package:equatable/equatable.dart';
import '../../../domain/entities/claim_activity_entity.dart';
import '../../../domain/entities/claim_coin_entity.dart';
import '../../../domain/entities/coin_wallet_entity.dart';

enum CoinsStatus { initial, loading, success, failure }
enum CoinsClaimStatus { initial, submitting, success, failure }

class CoinsState extends Equatable {
  final CoinsStatus status;
  final CoinWalletEntity wallet;
  final String? errorMessage;
  final List<ClaimActivityEntity> activities;
  final CoinsStatus activitiesStatus;
  final String? activitiesError;
  final List<ClaimCoinEntity> claims;
  final CoinsStatus claimsStatus;
  final String? claimsError;
  final CoinsClaimStatus claimSubmitStatus;
  final String? claimSubmitMessage;

  const CoinsState({
    this.status = CoinsStatus.initial,
    this.wallet = const CoinWalletEntity(),
    this.errorMessage,
    this.activities = const [],
    this.activitiesStatus = CoinsStatus.initial,
    this.activitiesError,
    this.claims = const [],
    this.claimsStatus = CoinsStatus.initial,
    this.claimsError,
    this.claimSubmitStatus = CoinsClaimStatus.initial,
    this.claimSubmitMessage,
  });

  CoinsState copyWith({
    CoinsStatus? status,
    CoinWalletEntity? wallet,
    String? errorMessage,
    List<ClaimActivityEntity>? activities,
    CoinsStatus? activitiesStatus,
    String? activitiesError,
    List<ClaimCoinEntity>? claims,
    CoinsStatus? claimsStatus,
    String? claimsError,
    CoinsClaimStatus? claimSubmitStatus,
    String? claimSubmitMessage,
  }) {
    return CoinsState(
      status: status ?? this.status,
      wallet: wallet ?? this.wallet,
      errorMessage: errorMessage,
      activities: activities ?? this.activities,
      activitiesStatus: activitiesStatus ?? this.activitiesStatus,
      activitiesError: activitiesError,
      claims: claims ?? this.claims,
      claimsStatus: claimsStatus ?? this.claimsStatus,
      claimsError: claimsError,
      claimSubmitStatus: claimSubmitStatus ?? this.claimSubmitStatus,
      claimSubmitMessage: claimSubmitMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        wallet,
        errorMessage,
        activities,
        activitiesStatus,
        activitiesError,
        claims,
        claimsStatus,
        claimsError,
        claimSubmitStatus,
        claimSubmitMessage,
      ];
}
