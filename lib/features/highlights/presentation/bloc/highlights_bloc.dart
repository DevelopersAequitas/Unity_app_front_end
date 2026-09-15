import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/highlight_section.dart';
import '../../domain/usecases/get_highlight_sections_usecase.dart';
import 'highlights_event.dart';
import 'highlights_state.dart';

class HighlightsBloc extends Bloc<HighlightsEvent, HighlightsState> {
  final GetHighlightSectionsUseCase getHighlightSectionsUseCase;

  HighlightsBloc({required this.getHighlightSectionsUseCase})
      : super(const HighlightsState()) {
    on<HighlightsFetchRequested>(_onFetch);
    on<HighlightsRefreshRequested>(_onRefresh);
    on<HighlightsSearchChanged>(_onSearchChanged);
  }

  Future<void> _onFetch(
    HighlightsFetchRequested event,
    Emitter<HighlightsState> emit,
  ) async {
    if (state.allSections.isEmpty) {
      emit(state.copyWith(status: HighlightsStatus.loading));
    }
    try {
      final sections = await getHighlightSectionsUseCase();
      emit(state.copyWith(
        status: HighlightsStatus.success,
        allSections: sections,
        filteredSections: _applyFilter(sections, state.searchQuery),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HighlightsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefresh(
    HighlightsRefreshRequested event,
    Emitter<HighlightsState> emit,
  ) async {
    try {
      final sections = await getHighlightSectionsUseCase();
      emit(state.copyWith(
        status: HighlightsStatus.success,
        allSections: sections,
        filteredSections: _applyFilter(sections, state.searchQuery),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HighlightsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSearchChanged(
    HighlightsSearchChanged event,
    Emitter<HighlightsState> emit,
  ) {
    final query = event.query;
    final filtered = _applyFilter(state.allSections, query);
    emit(state.copyWith(
      searchQuery: query,
      filteredSections: filtered,
    ));
  }

  List<HighlightSection> _applyFilter(List<HighlightSection> list, String query) {
    if (query.trim().isEmpty) return list;
    final lower = query.toLowerCase().trim();
    return list.where((item) {
      final title = item.title.toLowerCase();
      final category = item.category.toLowerCase();
      final id = item.id.toLowerCase().replaceAll('_', ' ');
      return title.contains(lower) || category.contains(lower) || id.contains(lower);
    }).toList();
  }
}
