import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mjumbe/app/router/router_refresh_stream.dart';
import 'package:mjumbe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mjumbe/features/auth/presentation/bloc/auth_state.dart';
import 'package:mjumbe/features/auth/presentation/pages/login_page.dart';
import 'package:mjumbe/features/auth/presentation/pages/profile_page.dart';
import 'package:mjumbe/features/auth/presentation/pages/splash_page.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/features/news/presentation/pages/article_detail_page.dart';
import 'package:mjumbe/features/news/presentation/pages/bookmarks_page.dart';
import 'package:mjumbe/features/news/presentation/pages/main_shell_page.dart';
import 'package:mjumbe/features/news/presentation/pages/news_feed_page.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String newsFeed = '/';
  static const String bookmarks = '/bookmarks';
  static const String profile = '/profile';
  static const String articleDetail = '/article-detail';
  static const String login = '/login';

  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: splash,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (BuildContext context, GoRouterState state) {
        final authState = authBloc.state;
        final bool isSplash = state.matchedLocation == splash;
        final bool isLoggingIn = state.matchedLocation == login;

        if (authState is AuthInitial || authState is AuthLoading) {
          return isSplash ? null : splash;
        }

        final bool isAuthenticated = authState is AuthenticatedState;

        if (!isAuthenticated) {
          return isLoggingIn ? null : login;
        }

        if (isAuthenticated && (isSplash || isLoggingIn)) {
          return newsFeed;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: splash,
          name: 'splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),

        // Navigation principale avec 3 onglets
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainShellPage(navigationShell: navigationShell);
          },
          branches: [
            // Onglet 1 : Fil d'actualités
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: newsFeed,
                  name: 'newsFeed',
                  builder: (context, state) => const NewsFeedPage(),
                ),
              ],
            ),
            // Onglet 2 : Signets
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: bookmarks,
                  name: 'bookmarks',
                  builder: (context, state) => const BookmarksPage(),
                ),
              ],
            ),
            // Onglet 3 : Profil
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: profile,
                  name: 'profile',
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
          ],
        ),

        // Détail d'un article
        GoRoute(
          path: articleDetail,
          name: 'articleDetail',
          builder: (context, state) {
            final article = state.extra as ArticleEntity;
            return ArticleDetailPage(article: article);
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Page non trouvée : ${state.error}'),
        ),
      ),
    );
  }
}