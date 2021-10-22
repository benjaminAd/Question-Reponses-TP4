// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:questions_reponses/Utils/constants.dart';
import 'package:questions_reponses/cubit/dropdown_cubit.dart';
import 'package:questions_reponses/cubit/game_on_cubit.dart';
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );

    const colorScheme = ColorScheme.highContrastLight(
      primary: Color(0xFF5D1049),
      secondary: Color(0xFFE30425),
      primaryVariant: Color(0xFF5D1049),
      secondaryVariant: Color(0xFFE30425),
      surface: Color(0xFFFFFFFF),
      background: Color(0xFFF4E2ED),
      error: Color(0xFFB00020),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onSurface: Color(0xFF000000),
      onError: Color(0xFFFD9726),
      onBackground: Color(0xFF000000),
      brightness: Brightness.light,
    );

    final tabBarTheme = TabBarTheme(
      labelColor: colorScheme.secondary,
      unselectedLabelColor: colorScheme.onBackground,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );

    final floatingActionButtonTheme = FloatingActionButtonThemeData(
      elevation: 10,
    );

    final themeData = ThemeData(
      colorScheme: colorScheme,
      snackBarTheme: snackBarTheme,
      primaryColor: colorScheme.primary,
      backgroundColor: colorScheme.background,
      inputDecorationTheme: inputDecorationTheme,
      scaffoldBackgroundColor: colorScheme.background,
      floatingActionButtonTheme: floatingActionButtonTheme,
      tabBarTheme: tabBarTheme,
    );
    return MaterialApp(
        title: 'Questions réponses',
        debugShowCheckedModeBanner: false,
        theme: themeData,
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
  }
}
