
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import go_router
import 'dart:async';

// Placeholder for the screen defined in app_router.dart
// This is needed because SplashScreen itself might be displayed
// by the router before the initial redirection check completes.
class PlaceholderHomeScreen extends StatelessWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager (Placeholder)')),
      body: const Center(child: Text('Welcome! App structure will be built here.')),
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // No explicit navigation needed here anymore.
    // GoRouter's redirect logic handles navigating based on auth state
    // after the splash screen.
    // You might still want a minimum display time or wait for
    // certain initializations if they happen asynchronously here.

    // Example: Ensure splash is shown for at least 2 seconds
    // Timer(const Duration(seconds: 2), () {
    //    // If using FutureBuilder or similar for initializations,
    //    // navigation might happen there upon completion.
    //    // Otherwise, GoRouter handles it.
    // });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement a visually appealing splash screen
    // Using animations (Lottie, Rive), logo, etc.
    // Example using Lottie (ensure you add lottie asset to pubspec.yaml)
    /*
    try {
      return Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/lottie/splash_animation.json', // Replace with your Lottie file path
            width: 200,
            height: 200,
            fit: BoxFit.fill,
            onLoaded: (composition) {
              // You can control the animation here if needed
            },
          ),
        ),
      );
    } catch (e) {
      // Fallback if Lottie fails or asset not found
      print('Error loading Lottie animation: $e');
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    */

    // Simple placeholder splash screen
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading Task Manager...'),
          ],
        ),
      ),
    );
  }
}
