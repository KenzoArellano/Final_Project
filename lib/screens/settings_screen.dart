import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'home_screen.dart'; // Import HomeScreen class here
import '../providers/money_provider.dart'; // Import MoneyProvider

class SettingsScreen extends StatefulWidget {
  final Function toggleTheme; // Add a toggleTheme function to the constructor

  const SettingsScreen({super.key, required this.toggleTheme});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isPrivacyExpanded = false; // State to manage Privacy Policy dropdown
  bool _isAboutExpanded = false; // State to manage About dropdown
  String _selectedCurrency = 'USD'; // Default currency
  bool _isDarkMode = false; // Dark mode state

  // List of available currencies
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'INR', 'JPY', 'PHP'];

  @override
  Widget build(BuildContext context) {
    final moneyProvider = Provider.of<MoneyProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Settings",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Dark Mode with bold text
            ListTile(
              title: Text(
                _isDarkMode
                    ? "Light Mode :)"
                    : "Dark Mode >:(", // Change text based on dark mode state
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                  // Call the toggleTheme function passed from main.dart
                  widget.toggleTheme();
                },
              ),
            ),

            // Currency Selection Dropdown
            ListTile(
              title: const Text("Select Currency"),
              subtitle: Text("Current: $_selectedCurrency"),
              onTap: () async {
                // Show the currency selection dialog
                String? newCurrency = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text("Choose Currency"),
                      children: _currencies.map((currency) {
                        return SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context, currency);
                          },
                          child: Text(currency),
                        );
                      }).toList(),
                    );
                  },
                );
                if (newCurrency != null) {
                  setState(() {
                    _selectedCurrency = newCurrency;
                  });
                  // Update the currency in the MoneyProvider
                  moneyProvider.setCurrency(newCurrency);
                }
              },
            ),

            // Privacy Policy with Dropdown
            ListTile(
              title: const Text("Privacy Policy"),
              onTap: () {
                setState(() {
                  _isPrivacyExpanded = !_isPrivacyExpanded;
                });
              },
            ),
            if (_isPrivacyExpanded) // Show content if expanded
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Here are the details of our Privacy Policy. "
                  "We value your privacy and ensure the safety of your data.",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),

            // About Section with Dropdown
            ListTile(
              title: const Text("About"),
              onTap: () {
                setState(() {
                  _isAboutExpanded = !_isAboutExpanded;
                });
              },
            ),
            if (_isAboutExpanded) // Show content if expanded
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "This app is designed to help you manage your money effectively. "
                  "Version: 1.0.0\nDeveloped by: Your Name",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
          ],
        ),
      ),
      // Footer with buttons
      bottomNavigationBar: Container(
        color: Colors.grey[800],
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                // Directly navigate back to HomeScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.pie_chart, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(
                    context, '/analytics'); // Navigate to Analytics
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(
                    context, '/calendar'); // Navigate to Calendar
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                // Already on the Settings screen, no navigation needed
              },
            ),
          ],
        ),
      ),
    );
  }
}
