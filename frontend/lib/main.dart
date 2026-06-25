import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('user_id');
  runApp(MyApp(isLoggedIn: userId != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFDE8E8),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF9E6068),
          secondary: const Color(0xFFC4908A),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          surface: const Color(0xFFFDE8E8),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF9E6068),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9E6068),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF9E6068),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF9E6068),
          selectedItemColor: Colors.white,
          unselectedItemColor: Color(0xFFFDE8E8),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.all(const Color(0xFF9E6068)),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Color(0xFF9E6068)),
          prefixIconColor: const Color(0xFF9E6068),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFC4908A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF9E6068), width: 2),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF3D1A1F)),
          bodyMedium: TextStyle(color: Color(0xFF3D1A1F)),
          titleLarge: TextStyle(color: Color(0xFF3D1A1F), fontWeight: FontWeight.bold),
        ),
      ),
      home: isLoggedIn ? const HomeScreen() : const RegisterScreen(),
    );
  }
}