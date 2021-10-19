// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:questions_reponses/views/screen/firebase_init_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return FirebaseInit();
  }
}
