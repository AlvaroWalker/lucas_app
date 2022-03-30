import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  //final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  //await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCzf_pe7SKMI9BphGfxKcK-tL3W2gAKLIc",
          authDomain: "tabacaria-lucas.firebaseapp.com",
          projectId: "tabacaria-lucas",
          storageBucket: "tabacaria-lucas.appspot.com",
          messagingSenderId: "728690192177",
          appId: "1:728690192177:web:65800852a14a4ca9ec8a10"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch}),
      debugShowCheckedModeBanner: false,
      title: 'Tabacaria Strong',
      theme: ThemeData(
          //canvasColor: Color.fromARGB(1, 1, 1, 1),
          textTheme: GoogleFonts.lexendDecaTextTheme(
            Theme.of(context).textTheme,
          ),
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen)),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: GoogleFonts.lexendDeca().fontFamily,
          inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))))

          /* dark theme settings */
          ),
      themeMode: ThemeMode.dark,
      home: const MainAppPage());
}
