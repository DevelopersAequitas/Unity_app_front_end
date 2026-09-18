import 'package:equatable/equatable.dart';
import '../../../domain/entities/coin_wallet_entity.dart';

enum CoinsStatus { initial, loading, success, failure }

class CoinsState extends Equatable {
  final CoinsStatus status;
  final CoinWalletEntity wallet;
  final String? errorMessage;

  const CoinsState({
    this.status = CoinsStatus.initial,
    this.wallet = const CoinWalletEntity(),
    this.errorMessage,
  });

  CoinsState copyWith({
    CoinsStatus? status,
    CoinWalletEntity? wallet,
    String? errorMessage,
  }) {
    return CoinsState(
      status: status ?? this.status,
      wallet: wallet ?? this.wallet,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, wallet, errorMessage];
}
