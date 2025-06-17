import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kegiatan_mahasiswa/screens/home_screen.dart';
import 'package:kegiatan_mahasiswa/screens/add_data_screen.dart';
import 'package:kegiatan_mahasiswa/screens/detail_task_screen.dart';


const Color appBackgroundColor = Color(0xFFF1F2F6);
const Color primaryDarkColor = Color(0xFF201E43);
const Color secondaryDarkColor = Color(0xFF508C9B);
const Color lightTextColor = Colors.white; 
const Color darkTextColor = Color(0xFF201E43);

// Nama : Bagas Wira Kusuma
// NIM : 230441100054
// Asprak : Kak Kukuh

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Activity App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: appBackgroundColor,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: darkTextColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryDarkColor,
            foregroundColor: lightTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryDarkColor,
          foregroundColor: lightTextColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          filled: true,
          fillColor: secondaryDarkColor,
          hintStyle: TextStyle(color: lightTextColor.withOpacity(0.7)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/add': (context) => const AddActivityPage(),
        '/detail': (context) => const DetailTaskScreen(),
      },
    );
  }
}
