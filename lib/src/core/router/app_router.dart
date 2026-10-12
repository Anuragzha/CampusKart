import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:campus_kart/src/features/auth/presentation/screens/login_screen.dart';
import 'package:campus_kart/src/features/auth/presentation/screens/register_screen.dart';
import 'package:campus_kart/src/features/chat/presentation/screens/chat_screen.dart';
import 'package:campus_kart/src/features/chat/presentation/screens/inbox_screen.dart';
import 'package:campus_kart/src/features/listings/presentation/screens/categories_screen.dart';
import 'package:campus_kart/src/features/listings/presentation/screens/create_listing_screen.dart';
import 'package:campus_kart/src/features/listings/presentation/screens/home_screen.dart';
import 'package:campus_kart/src/features/listings/presentation/screens/listing_detail_screen.dart';
import 'package:campus_kart/src/features/listings/presentation/screens/my_listings_screen.dart';
import 'package:campus_kart/src/features/main_shell/main_shell.dart';
import 'package:campus_kart/src/features/profile/presentation/screens/profile_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Central router for CampusKart using go_router.
abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    debugLogDiagnostics: false,
    routes: [
      // ── Standalone auth routes ───────────────────────────────────────────
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // ── Standalone detail/create routes ──────────────────────────────────
      GoRoute(
        path: '/listing/:id',
        name: 'listing-detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ListingDetailScreen(listingId: id);
        },
      ),
      GoRoute(
        path: '/create-listing',
        name: 'create-listing',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateListingScreen(),
      ),
      GoRoute(
        path: '/categories',
        name: 'categories',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/chat/:chatId',
        name: 'chat',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final chatId = state.pathParameters['chatId'] ?? '';
          return ChatScreen(chatId: chatId);
        },
      ),

      // ── Main Shell with persistent bottom navigation ─────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Branch 1: Chats / Inbox
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inbox',
                name: 'inbox',
                builder: (context, state) => const InboxScreen(),
              ),
            ],
          ),

          // Branch 2: My Listings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/my-listings',
                name: 'my-listings',
                builder: (context, state) => const MyListingsScreen(),
              ),
            ],
          ),

          // Branch 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Root redirect to /home
      GoRoute(path: '/', redirect: (context, state) => '/home'),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}
