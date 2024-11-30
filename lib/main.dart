import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/income_screen.dart';
import 'screens/expense_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/analytics_screen.dart'; // Import AnalyticsScreen
import 'providers/money_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initialize the theme mode to light mode by default
  ThemeMode _themeMode = ThemeMode.light;

  // Function to toggle the theme mode
  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MoneyProvider>(
      create: (context) => MoneyProvider(),
      child: MaterialApp(
        title: 'Money Management',
        theme: ThemeData.light(), // Light theme
        darkTheme: ThemeData.dark(), // Dark theme
        themeMode: _themeMode, // Set the theme mode to either light or dark
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/home': (context) => const HomeScreen(),
          '/income': (context) => const IncomeScreen(),
          '/expense': (context) => const ExpenseScreen(),
          '/settings': (context) => SettingsScreen(
              toggleTheme:
                  _toggleTheme), // Pass the theme toggle to SettingsScreen
          '/calendar': (context) => const CalendarScreen(),
          '/analytics': (context) => const AnalyticsScreen(),
        },
      ),
    );
  }
}
