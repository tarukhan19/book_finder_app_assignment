import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_pallete.dart';
import '../../../../core/utils/debouncer.dart';
import '../bloc/search/book_search_bloc.dart';
import '../bloc/search/book_search_event.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  late Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final query = _controller.text.trim();
    _debouncer(() {
      if (query.isEmpty) {
        // Clear search results
        context.read<BookSearchBloc>().add(const ClearSearchEvent());
      } else if (query.length >= 2) {
        // Minimum 2 characters for search
        context.read<BookSearchBloc>().add(SearchBooksEvent(query: query));
      }
    });
  }

  void _clearSearch() {
    _controller.clear();
    context.read<BookSearchBloc>().add(const ClearSearchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppPallete.greyColor.withAlpha((0.5 * 255).round()),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search for books by title...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
            size: 24,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.grey.shade600,
            ),
            onPressed: _clearSearch,
            tooltip: 'Clear search',
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        onChanged: (value) {
          setState(() {}); // To show/hide clear button
          _onSearchChanged(value);
        },
        textInputAction: TextInputAction.search,
        autofocus: false,
      ),
    );
  }
}