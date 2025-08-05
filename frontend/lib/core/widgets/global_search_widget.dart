import 'package:fct_frontend/features/dashboard/presentation/providers/search_provider.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:fct_frontend/shared/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget de búsqueda global que se muestra en el AppBar
class GlobalSearchWidget extends ConsumerStatefulWidget {
  const GlobalSearchWidget({super.key});

  @override
  ConsumerState<GlobalSearchWidget> createState() => _GlobalSearchWidgetState();
}

class _GlobalSearchWidgetState extends ConsumerState<GlobalSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final searchNotifier = ref.read(searchStateProvider.notifier);
    searchNotifier.updateQuery(_searchController.text);

    // Obtener sugerencias después de un delay
    Future.delayed(const Duration(milliseconds: 300), () {
      searchNotifier.getSuggestions();
    });
  }

  void _expandSearch() {
    setState(() {
      _isSearchExpanded = true;
    });
    _searchFocusNode.requestFocus();
  }

  void _collapseSearch() {
    setState(() {
      _isSearchExpanded = false;
    });
    _searchController.clear();
    _searchFocusNode.unfocus();

    final searchNotifier = ref.read(searchStateProvider.notifier);
    searchNotifier.clearResults();
  }

  void _performSearch() {
    final searchNotifier = ref.read(searchStateProvider.notifier);
    searchNotifier.searchGlobal();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchStateProvider);
    final searchNotifier = ref.read(searchStateProvider.notifier);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isSearchExpanded ? 300 : 40,
      child: _isSearchExpanded
          ? _buildExpandedSearch(searchState, searchNotifier)
          : _buildCollapsedSearch(),
    );
  }

  Widget _buildCollapsedSearch() {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: _expandSearch,
      tooltip: AppLocalizations.of(context).search,
    );
  }

  Widget _buildExpandedSearch(
      SearchState searchState, SearchNotifier searchNotifier) {
    return Column(
      children: [
        _buildSearchField(searchState, searchNotifier),
        if (searchState.suggestions.isNotEmpty ||
            searchState.searchHistory.isNotEmpty)
          _buildSearchSuggestions(searchState, searchNotifier),
        if (searchState.results != null)
          _buildSearchResults(searchState.results!),
      ],
    );
  }

  Widget _buildSearchField(
      SearchState searchState, SearchNotifier searchNotifier) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).search,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                isDense: true,
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          if (searchState.isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: _collapseSearch,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions(
      SearchState searchState, SearchNotifier searchNotifier) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchState.suggestions.isNotEmpty) ...[
            _buildSuggestionSection(
              title: 'Sugerencias',
              items: searchState.suggestions,
              onTap: (item) => searchNotifier.selectSuggestion(item),
            ),
          ],
          if (searchState.searchHistory.isNotEmpty) ...[
            _buildSuggestionSection(
              title: 'Historial de búsqueda',
              items: searchState.searchHistory,
              onTap: (item) => searchNotifier.selectFromHistory(item),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionSection({
    required String title,
    required List<String> items,
    required Function(String) onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ),
        ...items.take(5).map((item) => _buildSuggestionItem(item, onTap)),
      ],
    );
  }

  Widget _buildSuggestionItem(String item, Function(String) onTap) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.history, size: 16),
      title: Text(
        item,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => onTap(item),
    );
  }

  Widget _buildSearchResults(GlobalSearchResult results) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Resultados de búsqueda (${results.totalResults})',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
          ),
          if (results.projects.isNotEmpty)
            _buildResultSection(
              title: AppLocalizations.of(context).projects,
              items:
                  results.projects.map((p) => _buildProjectResult(p)).toList(),
            ),
          if (results.users.isNotEmpty)
            _buildResultSection(
              title: AppLocalizations.of(context).users,
              items: results.users.map((u) => _buildUserResult(u)).toList(),
            ),
          if (results.tasks.isNotEmpty)
            _buildResultSection(
              title: AppLocalizations.of(context).tasks,
              items: results.tasks.map((t) => _buildTaskResult(t)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildResultSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...items.take(3),
      ],
    );
  }

  Widget _buildProjectResult(Project project) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.folder, size: 16),
      title: Text(
        project.title,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        project.description,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        // TODO: Navegar al proyecto
        _collapseSearch();
      },
    );
  }

  Widget _buildUserResult(User user) {
    final fullName = '${user.firstName} ${user.lastName}';
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 12,
        child: Text(
          user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : 'U',
          style: const TextStyle(fontSize: 12),
        ),
      ),
      title: Text(
        fullName,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        user.email,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        // TODO: Navegar al perfil del usuario
        _collapseSearch();
      },
    );
  }

  Widget _buildTaskResult(Task task) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.task, size: 16),
      title: Text(
        task.title,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        task.description,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        // TODO: Navegar a la tarea
        _collapseSearch();
      },
    );
  }
}
