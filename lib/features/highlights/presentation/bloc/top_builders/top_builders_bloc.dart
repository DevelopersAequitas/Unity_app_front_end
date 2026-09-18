import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_my_introduced_peers_usecase.dart';
import '../../../domain/usecases/get_top_builders_usecase.dart';
import 'top_builders_event.dart';
import 'top_builders_state.dart';

class TopBuildersBloc extends Bloc<TopBuildersEvent, TopBuildersState> {
  final GetTopBuildersUseCase getTopBuildersUseCase;
  final GetMyIntroducedPeersUseCase getMyIntroducedPeersUseCase;

  TopBuildersBloc({
    required this.getTopBuildersUseCase,
    required this.getMyIntroducedPeersUseCase,
  }) : super(const TopBuildersState()) {
    on<FetchTopBuildersDataEvent>(_onFetchData);
    on<SearchIntroducedPeersEvent>(_onSearch);
  }

  Future<void> _onFetchData(
    FetchTopBuildersDataEvent event,
    Emitter<TopBuildersState> emit,
  ) async {
    if (!event.isRefresh && state.status == TopBuildersStatus.initial) {
      emit(state.copyWith(status: TopBuildersStatus.loading));
    }
    try {
      final buildersFuture = getTopBuildersUseCase();
      final introducedFuture = getMyIntroducedPeersUseCase();
      final results = await Future.wait([buildersFuture, introducedFuture]);

      emit(state.copyWith(
        status: TopBuildersStatus.success,
        topBuilders: results[0] as dynamic,
        myIntroduced: results[1] as dynamic,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TopBuildersStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSearch(
    SearchIntroducedPeersEvent event,
    Emitter<TopBuildersState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
