import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/money_provider.dart';
import '../screens/home_screen.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Income"),
        backgroundColor: Colors.transparent, // Transparent AppBar background
        elevation: 0,
      ),
      body: Container(
        color: Colors.transparent, // Transparent body background
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Income Name TextField with dynamic colors based on theme
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Enter income name",
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isDarkMode ? Colors.white54 : Colors.black45,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isDarkMode ? Colors.blueAccent : Colors.blue,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // Income Amount TextField with dynamic colors based on theme
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Enter income amount",
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isDarkMode ? Colors.white54 : Colors.black45,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isDarkMode ? Colors.blueAccent : Colors.blue,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      final name = _nameController.text;
                      final amount = double.tryParse(_amountController.text);
                      if (name.isNotEmpty && amount != null) {
                        // Call the addIncome method from MoneyProvider
                        Provider.of<MoneyProvider>(context, listen: false)
                            .addIncome(name, amount, DateTime.now());
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 51, 51, 51),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Add Income",
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Footer with navigation buttons
      bottomNavigationBar: Container(
        color: Colors.grey[800], // Dark grey for the bottom navigation bar
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.pie_chart, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/analytics');
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/calendar');
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}
