import 'package:book_finder_app_assignment/config/theme/app_pallete.dart';
import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../config/route/route.dart';
import '../screens/book_detail_screen.dart';


class BookCardWidget extends StatelessWidget {
  final BookEntity book;

  const BookCardWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.pushBookDetail(context, book);

        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
        // );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        elevation: 2,
        color: AppPallete.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Cover
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 60,
                  height: 90,
                  child:
                      book.coverUrl.isNotEmpty
                          ? CachedNetworkImage(
                            imageUrl: book.coverUrl,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  color: Colors.grey.shade300,
                                  child: const Icon(
                                    Icons.book,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                ),
                          )
                          : Container(
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.book,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                ),
              ),
              const SizedBox(width: 16),
              // Book Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Author
                    if (book.authorName.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              book.authorString,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    // First Publish Year
                    if (book.firstPublishYear != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'First published: ${book.firstPublishYear}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    // Author Key (if available)
                    if (book.authorKey.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.key,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Author Key: ${book.authorKey.first}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
