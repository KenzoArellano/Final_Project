import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/money_provider.dart';
import 'calendar_screen.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moneyProvider = Provider.of<MoneyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
        backgroundColor: Colors.transparent, // Transparent AppBar background
        elevation: 0,
      ),
      body: Container(
        color: Colors.transparent, // Set the body background to transparent
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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

            // Recent Transactions Section
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTransactionList(moneyProvider),
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
                // Stay on the current Analytics screen
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

  // Widget for the transaction list
  Widget _buildTransactionList(MoneyProvider moneyProvider) {
    final allTransactions = [
      ...moneyProvider.recentIncome.map(
        (transaction) => {
          "name": transaction["name"],
          "amount": transaction["amount"],
          "date": transaction["date"],
          "type": "Income",
          "color": Colors.green,
        },
      ),
      ...moneyProvider.recentExpenses.map(
        (transaction) => {
          "name": transaction["name"],
          "amount": transaction["amount"],
          "date": transaction["date"],
          "type": "Expense",
          "color": Colors.red,
        },
      ),
    ];

    allTransactions.sort(
      (a, b) => (b["date"] as DateTime).compareTo(a["date"] as DateTime),
    );

    return Expanded(
      child: allTransactions.isEmpty
          ? const Center(
              child: Text(
                'No recent transactions found.',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            )
          : ListView.builder(
              itemCount: allTransactions.length,
              itemBuilder: (context, index) {
                final transaction = allTransactions[index];
                return ListTile(
                  title: Text(transaction["name"]),
                  subtitle: Text(transaction["type"]),
                  leading: Icon(
                    transaction["type"] == "Income"
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: transaction["color"],
                  ),
                  trailing: Text(
                    moneyProvider.formatCurrency(transaction["amount"]),
                  ),
                );
              },
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
