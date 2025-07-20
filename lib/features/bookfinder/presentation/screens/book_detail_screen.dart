import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_pallete.dart';
import '../../../../core/di/injection.dart';
import '../bloc/bookmark/Bookmark_bloc.dart';
import '../bloc/bookmark/bookmark_event.dart';
import '../bloc/bookmark/bookmark_state.dart';

class BookDetailScreen extends StatelessWidget {
  final BookEntity book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookmarkBloc>()
        ..add(CheckBookmarkStatusEvent(book: book)),
      child: BookDetailView( book: book),
    );
  }
}

class BookDetailView extends StatelessWidget {
  final BookEntity book;
  const BookDetailView({super.key, required this.book});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Book Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppPallete.whiteColor,
          ),
        ),
        backgroundColor: AppPallete.blueColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppPallete.whiteColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          BlocConsumer<BookmarkBloc, BookmarkState>(
            listener: (context, state) {
              if (state is BookmarkToggled) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    duration: const Duration(seconds: 2),
                    backgroundColor: state.isBookmarked ? Colors.green : Colors.orange,
                  ),
                );
              } else if (state is BookmarkError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              bool isBookmarked = false;
              bool isLoading = false;

              if (state is BookmarkStatusLoaded) {
                isBookmarked = state.isBookmarked;
              } else if (state is BookmarkToggled) {
                isBookmarked = state.isBookmarked;
              } else if (state is BookmarkLoading) {
                isLoading = true;
              }

              return IconButton(
                onPressed: isLoading
                    ? null
                    : () {
                  context.read<BookmarkBloc>().add(
                    ToggleBookmarkEvent(book: book),
                  );
                },
                icon: isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                  size: 26,
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Book Cover Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppPallete.whiteColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha((0.5 * 255).round()),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Cover Image
                  Center(
                    child: Container(
                      width: 180,
                      height: 270,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.5 * 255).round()),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: book.coverUrl.isNotEmpty
                            ? CachedNetworkImage(
                          imageUrl: book.coverUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.book,
                              color: AppPallete.greyColor,
                              size: 80,
                            ),
                          ),
                        )
                            : Container(
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.book,
                            color: AppPallete.greyColor,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Book Title
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.blackColor,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Book Information Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppPallete.whiteColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha((0.5 * 255).round()),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title
                  const Text(
                    'Book Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.blackColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Author Name
                  if (book.authorName.isNotEmpty) ...[
                    _DetailItem(
                      icon: Icons.person,
                      title: 'Author${book.authorName.length > 1 ? 's' : ''}',
                      content: book.authorString,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // First Publish Year
                  if (book.firstPublishYear != null) ...[
                    _DetailItem(
                      icon: Icons.calendar_today,
                      title: 'First Published',
                      content: book.firstPublishYear.toString(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Author Key
                  if (book.authorKey.isNotEmpty) ...[
                    _DetailItem(
                      icon: Icons.key,
                      title: 'Author Key${book.authorKey.length > 1 ? 's' : ''}',
                      content: book.authorKey.join(', '),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Back Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.blueColor,
                  foregroundColor: AppPallete.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 2,
                ),
                child: const Text(
                  'Back to Search',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppPallete.blueColor.withAlpha((0.5 * 255).round()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppPallete.blueColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppPallete.blackColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
