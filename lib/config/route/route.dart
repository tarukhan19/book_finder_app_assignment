import 'package:book_finder_app_assignment/config/route/route_constant.dart';
import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:book_finder_app_assignment/features/bookfinder/presentation/screens/book_detail_screen.dart';
import 'package:book_finder_app_assignment/features/bookfinder/presentation/screens/book_search_screen.dart';
import 'package:book_finder_app_assignment/features/bookfinder/presentation/screens/dashboard_screen.dart';
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
      GoRoute(
        name: RouteConstant.dashboardPage,
        path: '/dashboard',
        pageBuilder: (context, state) {
          return const MaterialPage(child: DashboardScreen());
        },
      ),
    ],
  );

  static GoRouter get router => _router;

  static void pushBookDetail(BuildContext context, BookEntity book) {
    context.pushNamed(
      RouteConstant.bookDetailPage,
      extra: book,
    );
  }

  static void pushDashboard(BuildContext context) {
    context.pushNamed(
      RouteConstant.dashboardPage,
    );
  }
}