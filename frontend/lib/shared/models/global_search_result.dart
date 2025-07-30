import 'package:fct_frontend/shared/models/models.dart';

/// Resultado de una búsqueda global en el sistema
class GlobalSearchResult {
  final List<Project> projects;
  final List<User> users;
  final List<Task> tasks;
  final int totalResults;
  final String query;
  final int searchTime;

  const GlobalSearchResult({
    this.projects = const [],
    this.users = const [],
    this.tasks = const [],
    this.totalResults = 0,
    this.query = '',
    this.searchTime = 0,
  });

  factory GlobalSearchResult.fromJson(Map<String, dynamic> json) {
    return GlobalSearchResult(
      projects: (json['projects'] as List<dynamic>?)
              ?.map((e) => Project.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalResults: json['totalResults'] as int? ?? 0,
      query: json['query'] as String? ?? '',
      searchTime: json['searchTime'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projects': projects.map((e) => e.toJson()).toList(),
      'users': users.map((e) => e.toJson()).toList(),
      'tasks': tasks.map((e) => e.toJson()).toList(),
      'totalResults': totalResults,
      'query': query,
      'searchTime': searchTime,
    };
  }
}

/// Filtros para la búsqueda global
class SearchFilters {
  final List<String> categories;
  final List<String> statuses;
  final List<String> roles;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String sortBy;
  final String sortOrder;

  const SearchFilters({
    this.categories = const [],
    this.statuses = const [],
    this.roles = const [],
    this.dateFrom,
    this.dateTo,
    this.sortBy = '',
    this.sortOrder = 'desc',
  });

  factory SearchFilters.fromJson(Map<String, dynamic> json) {
    return SearchFilters(
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      statuses: (json['statuses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      dateFrom: json['dateFrom'] != null
          ? DateTime.parse(json['dateFrom'] as String)
          : null,
      dateTo: json['dateTo'] != null
          ? DateTime.parse(json['dateTo'] as String)
          : null,
      sortBy: json['sortBy'] as String? ?? '',
      sortOrder: json['sortOrder'] as String? ?? 'desc',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories,
      'statuses': statuses,
      'roles': roles,
      'dateFrom': dateFrom?.toIso8601String(),
      'dateTo': dateTo?.toIso8601String(),
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };
  }
}

/// Sugerencia de búsqueda
class SearchSuggestion {
  final String query;
  final String category;
  final int frequency;
  final String lastUsed;

  const SearchSuggestion({
    this.query = '',
    this.category = '',
    this.frequency = 0,
    this.lastUsed = '',
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      query: json['query'] as String? ?? '',
      category: json['category'] as String? ?? '',
      frequency: json['frequency'] as int? ?? 0,
      lastUsed: json['lastUsed'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'category': category,
      'frequency': frequency,
      'lastUsed': lastUsed,
    };
  }
}
