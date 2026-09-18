import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../peers/domain/usecases/get_all_peers_usecase.dart';
import '../../../profile/domain/usecases/upload_file_usecase.dart';
import '../../data/datasources/testimonials_remote_datasource.dart';
import '../../domain/entities/create_testimonial_params.dart';
import '../../domain/usecases/create_testimonial_usecase.dart';
import 'add_testimonial_event.dart';
import 'add_testimonial_state.dart';

class AddTestimonialBloc extends Bloc<AddTestimonialEvent, AddTestimonialState> {
  final CreateTestimonialUseCase createTestimonialUseCase;
  final GetAllPeersUseCase getAllPeersUseCase;
  final UploadProfileMediaUseCase uploadFileUseCase;

  AddTestimonialBloc({
    required this.createTestimonialUseCase,
    required this.getAllPeersUseCase,
    required this.uploadFileUseCase,
  }) : super(const AddTestimonialState()) {
    on<AddTestimonialPeerSearchRequested>(_onSearchPeers);
    on<AddTestimonialPeerSelected>(_onSelectPeer);
    on<AddTestimonialMessageChanged>(_onMessageChanged);
    on<AddTestimonialRatingChanged>(_onRatingChanged);
    on<AddTestimonialImageSelected>(_onImageSelected);
    on<AddTestimonialSubmitted>(_onSubmit);
    on<AddTestimonialReset>(_onReset);
  }

  Future<void> _onSearchPeers(
    AddTestimonialPeerSearchRequested event,
    Emitter<AddTestimonialState> emit,
  ) async {
    emit(state.copyWith(isSearchingPeers: true));
    try {
      final peers = await getAllPeersUseCase(
        search: event.query.isNotEmpty ? event.query : null,
        limit: 25,
      );
      final filtered = peers.where((p) {
        final displayName = p.displayName.toLowerCase();
        final first = (p.firstName ?? '').toLowerCase();
        final last = (p.lastName ?? '').toLowerCase();
        final company = (p.companyName ?? '').toLowerCase();
        return !displayName.contains('genie') &&
            !first.contains('genie') &&
            !last.contains('genie') &&
            !company.contains('peersglobal genie');
      }).toList();
      emit(state.copyWith(
        peerSearchResults: filtered,
        isSearchingPeers: false,
      ));
    } catch (_) {
      emit(state.copyWith(isSearchingPeers: false));
    }
  }

  void _onSelectPeer(
    AddTestimonialPeerSelected event,
    Emitter<AddTestimonialState> emit,
  ) {
    emit(state.copyWith(
      selectedPeer: event.peer,
      clearPeer: event.peer == null,
    ));
  }

  void _onMessageChanged(
    AddTestimonialMessageChanged event,
    Emitter<AddTestimonialState> emit,
  ) {
    emit(state.copyWith(message: event.message));
  }

  void _onRatingChanged(
    AddTestimonialRatingChanged event,
    Emitter<AddTestimonialState> emit,
  ) {
    emit(state.copyWith(rating: event.rating));
  }

  void _onImageSelected(
    AddTestimonialImageSelected event,
    Emitter<AddTestimonialState> emit,
  ) {
    emit(state.copyWith(
      selectedImage: event.imageFile,
      clearImage: event.imageFile == null,
    ));
  }

  Future<void> _onSubmit(
    AddTestimonialSubmitted event,
    Emitter<AddTestimonialState> emit,
  ) async {
    if (!state.isValid) {
      emit(state.copyWith(
        status: AddTestimonialStatus.failure,
        errorMessage: 'Please select a peer and write a message.',
      ));
      return;
    }

    emit(state.copyWith(status: AddTestimonialStatus.submitting));

    try {
      String? mediaId;
      if (state.selectedImage != null) {
        try {
          mediaId = await uploadFileUseCase(state.selectedImage!);
        } catch (_) {
          // If media fails, surface clear error
          emit(state.copyWith(
            status: AddTestimonialStatus.failure,
            errorMessage: 'Failed to upload attached image. Please try again.',
          ));
          return;
        }
      }

      final params = CreateTestimonialParams(
        givenToUserId: state.selectedPeer!.id,
        message: state.message.trim(),
        rating: state.rating > 0 ? state.rating : null,
        mediaId: mediaId,
      );

      final created = await createTestimonialUseCase(params);
      emit(state.copyWith(
        status: AddTestimonialStatus.success,
        createdTestimonial: created,
      ));
    } on ProMembershipRequiredException catch (e) {
      emit(state.copyWith(
        status: AddTestimonialStatus.requiresPro,
        errorMessage: e.message,
      ));
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('pro') || msg.contains('membership')) {
        emit(state.copyWith(
          status: AddTestimonialStatus.requiresPro,
          errorMessage: 'Upgrade to Pro to give testimonials to your peers.',
        ));
      } else {
        emit(state.copyWith(
          status: AddTestimonialStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }

  void _onReset(
    AddTestimonialReset event,
    Emitter<AddTestimonialState> emit,
  ) {
    emit(const AddTestimonialState());
  }
}
