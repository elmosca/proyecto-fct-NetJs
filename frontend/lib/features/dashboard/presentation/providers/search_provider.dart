import 'package:fct_frontend/core/services/search_service.dart';
import 'package:fct_frontend/shared/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider para el servicio de búsqueda
final searchServiceProvider = Provider<SearchService>((ref) {
  // TODO: Obtener desde GetIt cuando esté configurado
  throw UnimplementedError('SearchService debe ser configurado en GetIt');
});

/// Estado de la búsqueda global
class SearchState {
  final String query;
  final GlobalSearchResult? results;
  final List<String> suggestions;
  final List<String> searchHistory;
  final bool isLoading;
  final String? error;
  final SearchFilters filters;

  const SearchState({
    this.query = '',
    this.results,
    this.suggestions = const [],
    this.searchHistory = const [],
    this.isLoading = false,
    this.error,
    this.filters = const SearchFilters(),
  });

  SearchState copyWith({
    String? query,
    GlobalSearchResult? results,
    List<String>? suggestions,
    List<String>? searchHistory,
    bool? isLoading,
    String? error,
    SearchFilters? filters,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      searchHistory: searchHistory ?? this.searchHistory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filters: filters ?? this.filters,
    );
  }
}

/// Notifier para el estado de búsqueda global
class SearchNotifier extends StateNotifier<SearchState> {
  final Ref _ref;

  SearchNotifier(this._ref) : super(const SearchState());

  /// Actualiza la consulta de búsqueda
  void updateQuery(String query) {
    state = state.copyWith(query: query);

    // Si la consulta está vacía, limpiar resultados
    if (query.isEmpty) {
      state = state.copyWith(results: null, error: null);
    }
  }

  /// Realiza una búsqueda global
  Future<void> searchGlobal() async {
    if (state.query.trim().isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final searchService = _ref.read(searchServiceProvider);
      final results = await searchService.searchGlobal(
        query: state.query.trim(),
        filters: state.filters.toJson(),
      );

      // Guardar en historial
      await searchService.saveSearchHistory(state.query.trim());

      state = state.copyWith(
        results: results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Obtiene sugerencias de búsqueda
  Future<void> getSuggestions() async {
    if (state.query.trim().isEmpty) {
      state = state.copyWith(suggestions: []);
      return;
    }

    try {
      final searchService = _ref.read(searchServiceProvider);
      final suggestions = await searchService.getSearchSuggestions(
        state.query.trim(),
      );

      state = state.copyWith(suggestions: suggestions);
    } catch (e) {
      // No mostrar error para sugerencias, solo usar lista vacía
      state = state.copyWith(suggestions: []);
    }
  }

  /// Carga el historial de búsquedas
  Future<void> loadSearchHistory() async {
    try {
      final searchService = _ref.read(searchServiceProvider);
      final history = await searchService.getSearchHistory();

      state = state.copyWith(searchHistory: history);
    } catch (e) {
      // No mostrar error para historial, solo usar lista vacía
      state = state.copyWith(searchHistory: []);
    }
  }

  /// Actualiza los filtros de búsqueda
  void updateFilters(SearchFilters filters) {
    state = state.copyWith(filters: filters);
  }

  /// Limpia los resultados de búsqueda
  void clearResults() {
    state = state.copyWith(
      results: null,
      error: null,
    );
  }

  /// Limpia el error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Selecciona una sugerencia
  void selectSuggestion(String suggestion) {
    state = state.copyWith(query: suggestion);
    searchGlobal();
  }

  /// Selecciona un elemento del historial
  void selectFromHistory(String query) {
    state = state.copyWith(query: query);
    searchGlobal();
  }
}

/// Provider para acceder al estado de búsqueda
final searchStateProvider = StateNotifierProvider<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(ref),
);
