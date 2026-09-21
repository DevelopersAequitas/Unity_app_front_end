import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/accept_collaboration_usecase.dart';
import '../../domain/usecases/get_collaboration_history_usecase.dart';
import '../../domain/usecases/get_collaboration_types_usecase.dart';
import '../../domain/usecases/get_industries_tree_usecase.dart';
import '../../domain/usecases/submit_collaboration_usecase.dart';
import 'collaborations_event.dart';
import 'collaborations_state.dart';

class CollaborationsBloc extends Bloc<CollaborationsEvent, CollaborationsState> {
  final GetIndustriesTreeUseCase getIndustriesTree;
  final GetCollaborationTypesUseCase getCollaborationTypes;
  final SubmitCollaborationUseCase submitCollaboration;
  final GetCollaborationHistoryUseCase getCollaborationHistory;
  final AcceptCollaborationUseCase acceptCollaboration;

  CollaborationsBloc({
    required this.getIndustriesTree,
    required this.getCollaborationTypes,
    required this.submitCollaboration,
    required this.getCollaborationHistory,
    required this.acceptCollaboration,
  }) : super(const CollaborationsState()) {
    on<LoadCollaborationsInitialData>(_onLoadInitialData);
    on<SubmitCollaborationEvent>(_onSubmitCollaboration);
    on<FetchCollaborationHistoryEvent>(_onFetchCollaborationHistory);
    on<AcceptCollaborationEvent>(_onAcceptCollaboration);
  }

  Future<void> _onLoadInitialData(
    LoadCollaborationsInitialData event,
    Emitter<CollaborationsState> emit,
  ) async {
    emit(state.copyWith(status: CollaborationsStatus.loading));
    try {
      final results = await Future.wait([
        getIndustriesTree(),
        getCollaborationTypes(),
        getCollaborationHistory(),
      ]);

      emit(state.copyWith(
        status: CollaborationsStatus.loaded,
        industries: results[0] as dynamic,
        collaborationTypes: results[1] as dynamic,
        collaborations: results[2] as dynamic,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CollaborationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSubmitCollaboration(
    SubmitCollaborationEvent event,
    Emitter<CollaborationsState> emit,
  ) async {
    emit(state.copyWith(status: CollaborationsStatus.submitting));
    try {
      await submitCollaboration(event.params);
      emit(state.copyWith(
        status: CollaborationsStatus.success,
        successMessage: 'Collaboration opportunity submitted successfully.',
      ));
      add(const FetchCollaborationHistoryEvent());
    } catch (e) {
      emit(state.copyWith(
        status: CollaborationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFetchCollaborationHistory(
    FetchCollaborationHistoryEvent event,
    Emitter<CollaborationsState> emit,
  ) async {
    try {
      final list = await getCollaborationHistory();
      emit(state.copyWith(
        status: CollaborationsStatus.loaded,
        collaborations: list,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CollaborationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAcceptCollaboration(
    AcceptCollaborationEvent event,
    Emitter<CollaborationsState> emit,
  ) async {
    emit(state.copyWith(status: CollaborationsStatus.loading));
    try {
      await acceptCollaboration(event.collaborationId);
      emit(state.copyWith(
        status: CollaborationsStatus.success,
        successMessage: 'Collaboration accepted successfully!',
      ));
      add(const FetchCollaborationHistoryEvent());
    } catch (e) {
      emit(state.copyWith(
        status: CollaborationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
