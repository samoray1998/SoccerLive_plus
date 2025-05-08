import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF1E88E5);
  static const Color accentColor = Color(0xFF43A047);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFBDBDBD);
  static const Color errorColor = Color(0xFFD32F2F);
  
  // Dark theme colors
  static const Color darkPrimaryColor = Color(0xFF1976D2);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color darkTextColor = Colors.white;
  static const Color darkSecondaryTextColor = Color(0xFFB0B0B0);
  
  // Text styles
  static const TextStyle headlineStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textColor,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: textColor,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: secondaryTextColor,
  );
  
  // Light theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
      surface: cardColor,
      background: backgroundColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    dividerColor: dividerColor,
    appBarTheme: const AppBarTheme(
      color: primaryColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: secondaryTextColor,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: secondaryTextColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    textTheme: const TextTheme(
      headlineLarge: headlineStyle,
      titleLarge: titleStyle,
      titleMedium: subtitleStyle,
      bodyMedium: bodyStyle,
      bodySmall: captionStyle,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
  
  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: darkPrimaryColor,
    colorScheme: ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: accentColor,
      error: errorColor,
      surface: darkCardColor,
      background: darkBackgroundColor,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    cardColor: darkCardColor,
    dividerColor: dividerColor,
    appBarTheme: const AppBarTheme(
      color: darkPrimaryColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: darkSecondaryTextColor,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: darkPrimaryColor, width: 2),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkCardColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: darkSecondaryTextColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    textTheme: TextTheme(
      headlineLarge: headlineStyle.copyWith(color: darkTextColor),
      titleLarge: titleStyle.copyWith(color: darkTextColor),
      titleMedium: subtitleStyle.copyWith(color: darkTextColor),
      bodyMedium: bodyStyle.copyWith(color: darkTextColor),
      bodySmall: captionStyle.copyWith(color: darkSecondaryTextColor),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: darkPrimaryColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
