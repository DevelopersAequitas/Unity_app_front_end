import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_coin_wallet_data_usecase.dart';
import 'coins_event.dart';
import 'coins_state.dart';

class CoinsBloc extends Bloc<CoinsEvent, CoinsState> {
  final GetCoinWalletDataUseCase getCoinWalletDataUseCase;

  CoinsBloc({
    required this.getCoinWalletDataUseCase,
  }) : super(const CoinsState()) {
    on<FetchCoinsWalletEvent>(_onFetchWallet);
  }

  Future<void> _onFetchWallet(
    FetchCoinsWalletEvent event,
    Emitter<CoinsState> emit,
  ) async {
    if (!event.isRefresh && state.status == CoinsStatus.initial) {
      emit(state.copyWith(status: CoinsStatus.loading));
    }
    try {
      final wallet = await getCoinWalletDataUseCase();
      emit(state.copyWith(
        status: CoinsStatus.success,
        wallet: wallet,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CoinsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
