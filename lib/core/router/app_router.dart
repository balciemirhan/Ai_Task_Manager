
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:myapp/core/services/storage_service.dart'; // Import StorageService
import 'package:myapp/features/auth/presentation/screens/login_screen.dart';
import 'package:myapp/features/auth/presentation/screens/register_screen.dart';
import 'package:myapp/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:myapp/features/splash/splash_screen.dart';
import 'package:myapp/features/tasks/presentation/screens/task_list_screen.dart'; // Import TaskListScreen

// --- Placeholder Screens (Keep ErrorScreen for now) ---
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//   @override
//   Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Home')), body: Center(child: Text('Welcome Home!')));
// }

class ErrorScreen extends StatelessWidget {
  final Exception? error;
  const ErrorScreen({super.key, this.error});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Error')), body: Center(child: Text(error?.toString() ?? 'Page not found')));
}
// --- End Placeholder Screens ---


class AppRouter {
  static final StorageService _storageService = StorageService();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splashPath,
    debugLogDiagnostics: true,

    routes: [
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingPath,
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerPath,
        name: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      // Main App Route - Now points to TaskListScreen
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.home,
        builder: (context, state) => const TaskListScreen(), // Replaced placeholder
         // TODO: Add nested routes for task details, profile, settings etc.
         // Example for task detail:
         // routes: [
         //   GoRoute(
         //     path: 'task/:taskId', // Example: /home/task/123
         //     name: AppRoutes.taskDetail,
         //     builder: (context, state) {
         //       final taskId = state.pathParameters['taskId'];
         //       // TODO: Create and return TaskDetailScreen(taskId: taskId);
         //       return Scaffold(appBar: AppBar(), body: Center(child: Text('Detail for task: $taskId')));
         //     },
         //   ),
         // ],
      ),
    ],

    errorBuilder: (context, state) => ErrorScreen(error: state.error),

    redirect: (context, state) async {
      final auth = FirebaseAuth.instance;
      final loggedIn = auth.currentUser != null;
      final onboardingComplete = await _storageService.isOnboardingComplete();

      final isGoingToSplash = state.matchedLocation == AppRoutes.splashPath;
      final isGoingToOnboarding = state.matchedLocation == AppRoutes.onboardingPath;
      final authRoutes = [AppRoutes.loginPath, AppRoutes.registerPath];
      final isGoingToAuthRoute = authRoutes.contains(state.matchedLocation);

      if (isGoingToSplash) return null;

      if (!onboardingComplete && !isGoingToOnboarding) {
        return AppRoutes.onboardingPath;
      }

      if (onboardingComplete && isGoingToOnboarding) {
         return loggedIn ? AppRoutes.homePath : AppRoutes.loginPath;
      }

      // If onboarding is complete, proceed with auth checks
      if (!loggedIn && !isGoingToAuthRoute) {
        return AppRoutes.loginPath;
      }

      if (loggedIn && isGoingToAuthRoute) {
        return AppRoutes.homePath;
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  );
}

// Define route names and paths
class AppRoutes {
  static const String splash = 'splash';
  static const String splashPath = '/splash';

  static const String onboarding = 'onboarding';
  static const String onboardingPath = '/onboarding';

  static const String login = 'login';
  static const String loginPath = '/login';

  static const String register = 'register';
  static const String registerPath = '/register';

  static const String home = 'home';
  static const String homePath = '/home';

  // Example for nested route:
  // static const String taskDetail = 'taskDetail';
}

// Helper class (keep as is)
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
