// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questions_reponses/notifier/theme_provider.dart';
import 'package:questions_reponses/views/widget/error_view.dart';
import 'package:questions_reponses/views/widget/loading_view.dart';

import 'home.dart';

class FirebaseInit extends StatelessWidget {
  FirebaseInit({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    final inputDecorationTheme = InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final snackBarTheme = SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: ColorScheme.light().onBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final darksnackBarTheme = SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: ColorScheme.dark().onBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );

    const colorScheme = ColorScheme.light(
      primary: Color(0xFF9FFFE0),
      secondary: Color(0xFFFFBCAF),
      primaryVariant: Color(0xFF9FFFE0),
      secondaryVariant: Color(0xFFFFBCAF),
      surface: Color(0xFFFFFFFF),
      background: Color(0xFFF4E2ED),
      error: Color(0xFFB00020),
      onPrimary: Color(0xFF000000),
      onSecondary: Color(0xFF000000),
      onSurface: Color(0xFF000000),
      onError: Color(0xFFFD9726),
      onBackground: Color(0xFFFFFFFF),
      brightness: Brightness.light,
    );

    const darkcolorScheme = ColorScheme.dark(
      primary: Color(0xFF2BBD7E),
      secondary: Color(0xFFC85A54),
      primaryVariant: Color(0xFF2BBD7E),
      secondaryVariant: Color(0xFFC85A54),
      surface: Color(0xFFFFFFFF),
      background: Color(0xFF000000),
      error: Color(0xFFB00020),
      onPrimary: Color(0xFF000000),
      onSecondary: Color(0xFF000000),
      onSurface: Color(0xFF000000),
      onError: Color(0xFFFD9726),
      onBackground: Color(0xFFFFFFFF),
      brightness: Brightness.dark,
    );

    final tabBarTheme = TabBarTheme(
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
          ),
        ),
      ),
    );

    final floatingActionButtonTheme = FloatingActionButtonThemeData(
      elevation: 10,
    );

    final themeDataLight = ThemeData(
      colorScheme: colorScheme,
      snackBarTheme: snackBarTheme,
      primaryColor: colorScheme.primary,
      backgroundColor: colorScheme.background,
      inputDecorationTheme: inputDecorationTheme,
      scaffoldBackgroundColor: colorScheme.background,
      floatingActionButtonTheme: floatingActionButtonTheme,
      tabBarTheme: tabBarTheme,
    );

    final themeDataDark = ThemeData(
      colorScheme: darkcolorScheme,
      snackBarTheme: darksnackBarTheme,
      primaryColor: darkcolorScheme.primary,
      backgroundColor: darkcolorScheme.background,
      inputDecorationTheme: inputDecorationTheme,
      scaffoldBackgroundColor: darkcolorScheme.background,
      floatingActionButtonTheme: floatingActionButtonTheme,
      tabBarTheme: tabBarTheme,
    );

    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
            title: 'Questions réponses',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: themeDataLight,
            darkTheme: themeDataDark,
            home: FutureBuilder(
              future: _initialization,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ErrorView(error: snapshot.error.toString());
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return HomePage();
                }
                return Loading();
              },
            ));
      },
    );
  }
}
