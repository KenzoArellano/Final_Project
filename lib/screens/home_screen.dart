import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/money_provider.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moneyProvider = Provider.of<MoneyProvider>(context);

    // Debug: print income and expense values
    print("Total Income: ${moneyProvider.totalIncome}");
    print("Total Expense: ${moneyProvider.totalExpense}");

    // Determine the greeting based on the time of day
    String greeting = _getGreeting();

    // List of quirky saving tips
    List<String> savingTips = [
      "Stash a little cash every month – your future self will thank you! 💰",
      "Track your spending like a detective – who’s been stealing your money? 🕵️‍♂️",
      "Impulse purchases? Not today, shopping ninja! 🛑 Plan ahead.",
      "Create a budget and treat it like your financial GPS – no detours! 🛣️",
      "Set saving goals so big, you’ll need a rocket to reach them! 🚀",
      "Emergency fund: because life’s plot twists are way better when you're prepared. 📚",
      "Couponing: it’s like treasure hunting without leaving the couch. 🏴‍☠️",
      "Bulk buy – it’s like getting a family pack of savings! 🏷️",
      "Automate your savings like a robot – no effort required. 🤖",
      "Pay off that high-interest debt first – because who wants to pay more? 🏦",
      "Home-cooked meals: Because your kitchen is a 5-star restaurant. 🍴",
      "Credit cards with high balances? Let’s pretend they don’t exist. 💳🚫",
      "Price comparison: because a penny saved is a penny... well, you get it. 💸",
      "Shop during sales and laugh all the way to the checkout. 🛍️",
      "Save spare change – it adds up faster than you think! 💸💸",
      "Public transport or carpool – your wallet will be doing a happy dance. 🚌",
      "Set goals, short and long – like a marathon, but for your savings! 🏃‍♂️💨",
      "Free or low-cost fun? Oh yeah, they exist. 🎉",
      "Refinance loans and snag those sweet, sweet savings. 💸💸",
      "Switch to a cheaper phone plan – because ‘more data’ shouldn’t mean ‘more money’. 📱"
    ];

    // Get a random tip
    String savingTip = _getRandomSavingTip(savingTips);

    // Get current theme
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Money Management"),
        backgroundColor: Colors.transparent, // Transparent AppBar background
        elevation: 0,
      ),
      body: Container(
        color: Colors.transparent, // Set the body background to transparent
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Greeting Message
            Text(
              greeting,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Row for displaying total income, balance, and total expense
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildInfoSquare(
                    label: "Total Income",
                    value:
                        moneyProvider.formatCurrency(moneyProvider.totalIncome),
                    color: Colors.green, // Simple color for income
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoSquare(
                    label: "Balance",
                    value: moneyProvider.formatCurrency(moneyProvider.balance),
                    color: Colors.blueGrey, // Simple color for balance
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoSquare(
                    label: "Total Expense",
                    value: moneyProvider
                        .formatCurrency(moneyProvider.totalExpense),
                    color: Colors.red, // Simple color for expense
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            const SizedBox(height: 32),
            // Row for buttons to add income and expense
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildActionButton(context, "Add Income", '/income'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(context, "Add Expense", '/expense'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Saving Tips Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isDarkTheme
                    ? Colors.blueGrey.withOpacity(0.2)
                    : Colors.blueGrey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Saving Tip of the Day:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    savingTip,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkTheme ? Colors.white : Colors.blueGrey[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[800], // Dark grey for the bottom navigation bar
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CalendarScreen()),
                );
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

  // Function to get greeting based on the time of day
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning!";
    } else if (hour < 18) {
      return "Good Afternoon!";
    } else {
      return "Good Evening!";
    }
  }

  // Function to get a random saving tip from the list
  String _getRandomSavingTip(List<String> savingTips) {
    final random = Random();
    int index = random.nextInt(savingTips.length);
    return savingTips[index];
  }

  // Action Button widget for adding income and expenses
  Widget _buildActionButton(BuildContext context, String title, String route) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800], // Simple dark color for button
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(title, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  // Info Square widget for displaying balance, income, and expense
  Widget _buildInfoSquare(
      {required String label, required String value, required Color color}) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Light background with opacity
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: color)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 18, color: color)),
        ],
      ),
    );
  }
}
