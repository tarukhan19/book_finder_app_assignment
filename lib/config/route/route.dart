import 'package:book_finder_app_assignment/config/route/route_constant.dart';
import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:book_finder_app_assignment/features/bookfinder/presentation/screens/book_detail_screen.dart';
import 'package:book_finder_app_assignment/features/bookfinder/presentation/screens/book_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: RouteConstant.bookListPage,
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(child: BookSearchScreen());
        },
      ),
      GoRoute(
        name: RouteConstant.bookDetailPage,
        path: '/book-detail',
        pageBuilder: (context, state) {
          final book = state.extra as BookEntity;
          return MaterialPage(
            child: BookDetailScreen(book: book),
          );
        },
      ),
    ],
  );

  static GoRouter get router => _router;

  // Navigation helper methods
  static void goToBookList(BuildContext context) {
    context.goNamed(RouteConstant.bookListPage);
  }

  static void goToBookDetail(BuildContext context, BookEntity book) {
    context.goNamed(
      RouteConstant.bookDetailPage,
      extra: book,
    );
  }

  static void pushBookDetail(BuildContext context, BookEntity book) {
    context.pushNamed(
      RouteConstant.bookDetailPage,
      extra: book,
    );
  }
}