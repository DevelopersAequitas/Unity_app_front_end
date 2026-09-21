import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/features/profile/domain/usecases/upload_file_usecase.dart';
import '../../domain/usecases/requirements_usecases.dart';
import 'requirements_event.dart';
import 'requirements_state.dart';

class RequirementsBloc extends Bloc<RequirementsEvent, RequirementsState> {
  final GetOpenRequirementsUseCase getOpenRequirements;
  final GetMyRequirementsUseCase getMyRequirements;
  final CreateRequirementUseCase createRequirement;
  final CompleteRequirementUseCase completeRequirement;
  final FulfillRequirementUseCase fulfillRequirement;
  final UploadProfileMediaUseCase? uploadProfileMediaUseCase;

  RequirementsBloc({
    required this.getOpenRequirements,
    required this.getMyRequirements,
    required this.createRequirement,
    required this.completeRequirement,
    required this.fulfillRequirement,
    this.uploadProfileMediaUseCase,
  }) : super(const RequirementsState()) {
    on<FetchOpenRequirementsEvent>(_onFetchOpenRequirements);
    on<FetchMyRequirementsEvent>(_onFetchMyRequirements);
    on<CreateRequirementEvent>(_onCreateRequirement);
    on<CompleteRequirementEvent>(_onCompleteRequirement);
    on<FulfillRequirementEvent>(_onFulfillRequirement);
  }

  Future<void> _onFetchOpenRequirements(
    FetchOpenRequirementsEvent event,
    Emitter<RequirementsState> emit,
  ) async {
    emit(state.copyWith(status: RequirementsStatus.loading));
    try {
      final list = await getOpenRequirements();
      emit(state.copyWith(
        status: RequirementsStatus.loaded,
        openRequirements: list,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RequirementsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFetchMyRequirements(
    FetchMyRequirementsEvent event,
    Emitter<RequirementsState> emit,
  ) async {
    emit(state.copyWith(status: RequirementsStatus.loading));
    try {
      final list = await getMyRequirements();
      emit(state.copyWith(
        status: RequirementsStatus.loaded,
        myRequirements: list,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RequirementsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCreateRequirement(
    CreateRequirementEvent event,
    Emitter<RequirementsState> emit,
  ) async {
    emit(state.copyWith(status: RequirementsStatus.submitting));
    try {
      String? mediaId = event.mediaId;
      if (event.attachment != null && uploadProfileMediaUseCase != null) {
        mediaId = await uploadProfileMediaUseCase!(event.attachment!);
      }

      await createRequirement(
        subject: event.subject,
        description: event.description,
        category: event.category,
        regionLabel: event.regionLabel,
        cityName: event.cityName,
        mediaId: mediaId,
      );
      emit(state.copyWith(
        status: RequirementsStatus.success,
        successMessage: 'Requirement posted successfully!',
      ));
      add(const FetchMyRequirementsEvent());
      add(const FetchOpenRequirementsEvent());
    } catch (e) {
      emit(state.copyWith(
        status: RequirementsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCompleteRequirement(
    CompleteRequirementEvent event,
    Emitter<RequirementsState> emit,
  ) async {
    emit(state.copyWith(status: RequirementsStatus.submitting));
    try {
      await completeRequirement(event.id);
      emit(state.copyWith(
        status: RequirementsStatus.success,
        successMessage: 'Requirement marked as completed.',
      ));
      add(const FetchMyRequirementsEvent());
      add(const FetchOpenRequirementsEvent());
    } catch (e) {
      emit(state.copyWith(
        status: RequirementsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFulfillRequirement(
    FulfillRequirementEvent event,
    Emitter<RequirementsState> emit,
  ) async {
    emit(state.copyWith(status: RequirementsStatus.submitting));
    try {
      await fulfillRequirement(event.id, event.message);
      emit(state.copyWith(
        status: RequirementsStatus.success,
        successMessage: 'Response sent successfully!',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RequirementsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
