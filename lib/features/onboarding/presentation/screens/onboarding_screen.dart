
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // For SVG illustrations
import 'package:go_router/go_router.dart';
import 'package:myapp/core/router/app_router.dart';
import 'package:myapp/core/services/storage_service.dart'; // Import storage service
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Data model for a single onboarding page
class OnboardingPageModel {
  final String imagePath; // Path to SVG or PNG asset
  final String title;
  final String description;

  OnboardingPageModel({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final StorageService _storageService = StorageService(); // Instance of storage service
  bool _isLastPage = false;

  // TODO: Replace with your actual onboarding content and asset paths
  final List<OnboardingPageModel> _pages = [
    OnboardingPageModel(
      imagePath: 'assets/images/onboarding_1.svg', // Example path
      title: 'Welcome to Task Manager!',
      description: 'Organize your life and boost your productivity effortlessly.',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images/onboarding_2.svg', // Example path
      title: 'Create & Manage Tasks',
      description: 'Easily add, edit, and categorize your tasks with priorities and deadlines.',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images/onboarding_3.svg', // Example path
      title: 'Stay Notified',
      description: 'Get timely reminders so you never miss an important task.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _isLastPage = page == _pages.length - 1;
    });
  }

  Future<void> _completeOnboarding() async {
    await _storageService.setOnboardingComplete(true);
    // Navigate to the login screen (or home if already logged in, router handles this)
    if (mounted) {
       context.goNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button (Optional)
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: const Text('Skip'),
              ),
            ),
            // PageView for onboarding slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPageContent(page);
                },
              ),
            ),
            // Bottom Section: Indicator and Button
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(OnboardingPageModel page) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration (using flutter_svg)
          // Ensure you have placeholder or actual SVG files at the specified paths
          // and the assets folder is declared in pubspec.yaml
          SizedBox(
            height: 300.h, // Adjust height as needed
            child: SvgPicture.asset(
                    page.imagePath,
                    placeholderBuilder: (context) => const Center(child: CircularProgressIndicator()), // Placeholder
                 ),
           ),

          SizedBox(height: 40.h),
          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page Indicator
          SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: WormEffect( // Example effect, choose others like ExpandingDotsEffect
              dotHeight: 10.h,
              dotWidth: 10.w,
              activeDotColor: Theme.of(context).primaryColor,
            ),
          ),
          // Next/Get Started Button
          ElevatedButton(
            onPressed: () {
              if (_isLastPage) {
                _completeOnboarding();
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r), // Rounded corners
              ),
            ),
            child: Text(_isLastPage ? 'Get Started' : 'Next'),
          ),
        ],
      ),
    );
  }
}
