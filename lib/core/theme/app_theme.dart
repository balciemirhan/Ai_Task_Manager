
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Define custom colors if needed, e.g.:
// const Color primaryColor = Color(0xFF6200EE);
// const Color secondaryColor = Color(0xFF03DAC6);

class AppTheme {

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Colors.blue[600], // Example primary color
    scaffoldBackgroundColor: Colors.grey[50], // Light background
    colorScheme: ColorScheme.light(
      primary: Colors.blue[600]!, // Example primary color
      secondary: Colors.teal[400]!, // Example secondary color
      background: Colors.grey[50]!,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: Colors.black87,
      onSurface: Colors.black87,
      error: Colors.red[700]!,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue[600], // AppBar background
      foregroundColor: Colors.white, // AppBar text/icon color
      elevation: 1.0,
      titleTextStyle: GoogleFonts.lato(
          fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    textTheme: GoogleFonts.latoTextTheme(
      ThemeData.light().textTheme.copyWith(
            // Customize specific text styles if needed
            titleLarge: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            titleMedium: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            bodyMedium: TextStyle(fontSize: 14.sp),
          ).apply(bodyColor: Colors.black87, displayColor: Colors.black87),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.blue[600]!, width: 2.0),
      ),
      labelStyle: TextStyle(color: Colors.grey[700]),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
       style: ElevatedButton.styleFrom(
         backgroundColor: Colors.blue[600], // Button background
         foregroundColor: Colors.white, // Button text color
         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
         textStyle: GoogleFonts.lato(fontSize: 16.sp, fontWeight: FontWeight.bold),
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    ),
     floatingActionButtonTheme: FloatingActionButtonThemeData(
       backgroundColor: Colors.teal[400],
       foregroundColor: Colors.white,
     ),
     checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Colors.white),
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.blue[600]; // Color when checked
        }
        return Colors.grey[400]; // Color when unchecked
      }),
    ),
    cardTheme: CardTheme(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.blue[300], // Example dark theme primary
    scaffoldBackgroundColor: Colors.grey[900], // Dark background
    colorScheme: ColorScheme.dark(
      primary: Colors.blue[300]!, // Example dark theme primary
      secondary: Colors.teal[300]!, // Example dark theme secondary
      background: Colors.grey[900]!,
      surface: Colors.grey[800]!,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onBackground: Colors.white70,
      onSurface: Colors.white70,
      error: Colors.red[400]!,
      onError: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850], // Dark AppBar background
      foregroundColor: Colors.white70, // Dark AppBar text/icon color
      elevation: 1.0,
      titleTextStyle: GoogleFonts.lato(
          fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white70),
    ),
    textTheme: GoogleFonts.latoTextTheme(
       ThemeData.dark().textTheme.copyWith(
            titleLarge: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            titleMedium: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            bodyMedium: TextStyle(fontSize: 14.sp),
          ).apply(bodyColor: Colors.white70, displayColor: Colors.white70),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.blue[300]!, width: 2.0),
      ),
       labelStyle: TextStyle(color: Colors.grey[400]),
    ),
     elevatedButtonTheme: ElevatedButtonThemeData(
       style: ElevatedButton.styleFrom(
         backgroundColor: Colors.blue[300], // Dark button background
         foregroundColor: Colors.black, // Dark button text color
         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
         textStyle: GoogleFonts.lato(fontSize: 16.sp, fontWeight: FontWeight.bold),
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    ),
     floatingActionButtonTheme: FloatingActionButtonThemeData(
       backgroundColor: Colors.teal[300],
       foregroundColor: Colors.black,
     ),
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Colors.black),
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.blue[300]; // Color when checked
        }
        return Colors.grey[600]; // Color when unchecked
      }),
    ),
     cardTheme: CardTheme(
      elevation: 1.0,
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
