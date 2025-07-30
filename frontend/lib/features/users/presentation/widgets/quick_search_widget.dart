import 'dart:async';

import 'package:flutter/material.dart';

class QuickSearchWidget extends StatefulWidget {
  const QuickSearchWidget({
    super.key,
    required this.onSearch,
    this.hintText = 'Buscar usuarios...',
    this.debounceMs = 300,
  });

  final Function(String query) onSearch;
  final String hintText;
  final int debounceMs;

  @override
  State<QuickSearchWidget> createState() => _QuickSearchWidgetState();
}

class _QuickSearchWidgetState extends State<QuickSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: widget.debounceMs), () {
      if (mounted) {
        setState(() {
          _isSearching = true;
        });
        widget.onSearch(query);
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: _isSearching
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.2),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
