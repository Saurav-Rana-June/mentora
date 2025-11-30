import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Map<int, Color> swatch = {
  50: const Color.fromRGBO(29, 183, 204, .1),
  100: const Color.fromRGBO(29, 183, 204, .2),
  200: const Color.fromRGBO(29, 183, 204, .3),
  300: const Color.fromRGBO(29, 183, 204, .4),
  400: const Color.fromRGBO(29, 183, 204, .5),
  500: const Color.fromRGBO(29, 183, 204, .6),
  600: const Color.fromRGBO(29, 183, 204, .7),
  700: const Color.fromRGBO(29, 183, 204, .8),
  800: const Color.fromRGBO(29, 183, 204, .9),
  900: const Color.fromRGBO(29, 183, 204, 1),
};

Map<int, Color> slate = {
  50: Color(0xFFFAFAFA),
  100: Color(0xFFF5F5F5),
  200: Color(0xFFE5E5E5),
  300: Color(0xFFD4D4D4),
  400: Color(0xFFA3A3A3),
  500: Color(0xFF737373),
  600: Color(0xFF525252),
  700: Color(0xFF404040),
  800: Color(0xFF262626),
  900: Color(0xFF171717),
  950: Color(0xFF0A0A0A),
  1000: Color(0xFF000000),
};

Color white = const Color(0xFFFFFFFF);
Color black = const Color(0xFF000000);

Color primary = const Color(0xFFFA6403);

Color red = const Color(0xFFF87171);
Color red2 = const Color(0xFFEF4444);

Color blue = const Color(0xFF60A5FA);
Color blue2 = const Color(0xFF3B82F6);

Color purple = const Color(0xFFC084FC);
Color purple2 = const Color(0xFFA855F7);

Color orange = const Color(0xFFFB923C);
Color orange2 = const Color(0xFFF97316);

Color pink = const Color(0xFFF472B6);
Color pink2 = const Color(0xFFEC4899);

Color green = const Color(0xFF4ADE80);
Color green2 = const Color(0xFF22C55E);

Color teal = const Color(0xFF2DD4BF);
Color teal2 = const Color(0xFF14B8A6);

Color scaffoldColorLight = Color(0xFFFEF2E9);
Color scaffoldColorDark = Color(0xFF2D2E2B);

Color successColor = const Color(0xFF76BB70);
Color dangerColor = const Color(0xFFFF5C58);
Color warningColor = const Color(0xFFfea404);
Color infoColor = const Color(0xFF6CAAD8);

MaterialColor primarySwatch = MaterialColor(0xFF1DB7CC, swatch);

TextStyle h1 = TextStyle(
  fontFamily: "Satoshi",
  fontSize: 32.sp,
  fontWeight: FontWeight.w600,
);

TextStyle h2 = TextStyle(
  fontFamily: "Satoshi",
  fontSize: 24.sp,
  fontWeight: FontWeight.w600,
);

TextStyle h3 = TextStyle(
  fontFamily: "Satoshi",
  fontSize: 22.sp,
  fontWeight: FontWeight.w600,
);

TextStyle r20 = TextStyle(
  fontFamily: "Satoshi",
  fontSize: 20.sp,
  fontWeight: FontWeight.w400,
);

TextStyle r18 = TextStyle(
  fontFamily: "Satoshi",
  fontSize: 18.sp,
  fontWeight: FontWeight.w400,
);

TextStyle r16 = TextStyle(
  fontFamily: "Satoshi",
  fontSize: 16.sp,
  fontWeight: FontWeight.w400,
);

TextStyle r14 = TextStyle(
  fontFamily: "Satoshi",
  fontSize: 14.sp,
  fontWeight: FontWeight.w400,
);

TextStyle r12 = TextStyle(
  fontFamily: "Satoshi",
  fontSize: 12.sp,
  fontWeight: FontWeight.w400,
);

TextStyle r10 = TextStyle(
  fontFamily: "Satoshi",
  fontSize: 10.sp,
  fontWeight: FontWeight.w400,
);

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: "Satoshi",

    // COLORS
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: primarySwatch,
      brightness: Brightness.light,
    ).copyWith(primary: primary, secondary: primary, surface: white),
    scaffoldBackgroundColor: scaffoldColorLight,
    cardColor: scaffoldColorLight,

    // TEXT
    textTheme: TextTheme(
      bodyLarge: r16.copyWith(color: slate[900]),
      bodyMedium: r14.copyWith(color: slate[600]),
      bodySmall: r12.copyWith(color: slate[400]),
      headlineLarge: h1.copyWith(color: slate[800]),
      headlineMedium: h2.copyWith(color: slate[800]),
      headlineSmall: h3.copyWith(color: slate[800]),
    ),

    // APPBAR
    appBarTheme: AppBarTheme(
      backgroundColor: white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: slate[800]),
      titleTextStyle: h2.copyWith(color: slate[800]),
    ),

    // ICONS
    iconTheme: IconThemeData(color: slate[700]),

    // TABBAR
    tabBarTheme: TabBarThemeData(
      labelColor: primary,
      unselectedLabelColor: slate[600],
      indicatorColor: primary,
      dividerColor: slate[200],
    ),

    // BUTTONS
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: BorderSide(color: slate[300] ?? Colors.grey, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: r16.copyWith(color: slate[500]),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),

    // INPUT FIELDS
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: slate[100],
      contentPadding: const EdgeInsets.all(14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: slate[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: slate[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
      hintStyle: TextStyle(color: slate[400]),
    ),

    // BOTTOM NAV BAR
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: white,
      selectedItemColor: primary,
      unselectedItemColor: slate[500],
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),

    // SWITCH / CHECKBOX
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(white),
      trackColor: WidgetStateProperty.all(slate[200]),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(primary),
      checkColor: WidgetStateProperty.all(white),
    ),

    radioTheme: RadioThemeData(fillColor: WidgetStateProperty.all(primary)),

    // CARD
    cardTheme: CardThemeData(
      color: white,
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // SNACKBAR
    snackBarTheme: SnackBarThemeData(
      backgroundColor: slate[800],
      contentTextStyle: r14.copyWith(color: white),
      behavior: SnackBarBehavior.floating,
    ),

    // TOOLTIP
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: slate[800],
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TextStyle(color: white),
    ),

    // DIVIDERS
    dividerTheme: DividerThemeData(color: slate[100], thickness: 1),

    // LIST TILE
    listTileTheme: ListTileThemeData(
      iconColor: slate[800],
      textColor: slate[800],
    ),

    // FAB
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: white,
    ),
  );

  // --------------------- Dark Theme ------------------------------ //

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.inter().fontFamily,

    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: primarySwatch,
      brightness: Brightness.dark,
    ).copyWith(primary: primary, secondary: primary),

    scaffoldBackgroundColor: scaffoldColorDark,
    cardColor: scaffoldColorDark,

    textTheme: TextTheme(
      bodyLarge: r16.copyWith(color: white),
      bodyMedium: r14.copyWith(color: slate[400]),
      bodySmall: r12.copyWith(color: slate[400]),
      headlineLarge: h1.copyWith(color: white),
      headlineMedium: h2.copyWith(color: white),
      headlineSmall: h3.copyWith(color: white),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: scaffoldColorDark,
      elevation: 0,
      iconTheme: IconThemeData(color: white),
      titleTextStyle: h2.copyWith(color: white),
    ),

    iconTheme: IconThemeData(color: white),

    tabBarTheme: TabBarThemeData(
      labelColor: primary,
      unselectedLabelColor: slate[300],
      indicatorColor: primary,
      dividerColor: white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: BorderSide(color: white.withValues(alpha: 0.5), width: 1.2),
        textStyle: r16.copyWith(color: white.withValues(alpha: 0.9)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: slate[700],
      contentPadding: const EdgeInsets.all(14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: slate[600]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: slate[600]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
      hintStyle: TextStyle(color: slate[400]),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: scaffoldColorDark,
      selectedItemColor: primary,
      unselectedItemColor: slate[400],
      elevation: 12,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(primary),
      trackColor: WidgetStateProperty.all(slate[600]),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(primary),
      checkColor: WidgetStateProperty.all(white),
    ),

    radioTheme: RadioThemeData(fillColor: WidgetStateProperty.all(primary)),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: slate[900],
      contentTextStyle: r14.copyWith(color: white),
    ),

    dividerTheme: DividerThemeData(color: slate[600], thickness: 1),

    listTileTheme: const ListTileThemeData(
      textColor: Colors.white,
      iconColor: Colors.white,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: white,
    ),

    cardTheme: CardThemeData(
      color: Color(0xFF41423E),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
