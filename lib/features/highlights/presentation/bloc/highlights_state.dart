import 'package:equatable/equatable.dart';
import '../../domain/entities/highlight_section.dart';

enum HighlightsStatus { initial, loading, success, failure }

class HighlightsState extends Equatable {
  final HighlightsStatus status;
  final List<HighlightSection> allSections;
  final List<HighlightSection> filteredSections;
  final String searchQuery;
  final String? errorMessage;

  const HighlightsState({
    this.status = HighlightsStatus.initial,
    this.allSections = const [],
    this.filteredSections = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  HighlightsState copyWith({
    HighlightsStatus? status,
    List<HighlightSection>? allSections,
    List<HighlightSection>? filteredSections,
    String? searchQuery,
    String? errorMessage,
  }) {
    return HighlightsState(
      status: status ?? this.status,
      allSections: allSections ?? this.allSections,
      filteredSections: filteredSections ?? this.filteredSections,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allSections,
        filteredSections,
        searchQuery,
        errorMessage,
      ];
}
