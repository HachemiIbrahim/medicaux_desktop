import 'package:flutter/material.dart';
import 'package:medicaux_desktop/screen/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
//rgb(0, 152, 185)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        tabBarTheme: const TabBarTheme(unselectedLabelColor: Colors.grey),
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 83, 177, 117),
            primary: const Color.fromARGB(255, 0, 152, 185),
            secondary: const Color.fromARGB(255, 0, 56, 68),
            background: const Color.fromARGB(255, 255, 255, 255),
            onPrimary: Colors.deepPurpleAccent),
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: const LoginScreen(),
    );
  }
}
