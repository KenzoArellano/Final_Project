import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  Map<DateTime, Map<String, String>> _descriptions =
      {}; // Store descriptions by date

  String _transactionType = 'Income'; // Default transaction type
  TextEditingController _transactionNameController = TextEditingController();
  TextEditingController _transactionAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _loadDescriptions(); // Load descriptions from shared preferences
  }

  // Load saved descriptions from shared_preferences
  _loadDescriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? descriptionsString = prefs.getString('descriptions');
    if (descriptionsString != null) {
      // Decode the JSON string to a Map<DateTime, Map<String, String>>
      Map<String, dynamic> decodedDescriptions =
          json.decode(descriptionsString);
      setState(() {
        _descriptions = decodedDescriptions.map((key, value) {
          DateTime date = DateTime.parse(key);
          return MapEntry(date, Map<String, String>.from(value));
        });
      });
    }
  }

  // Save descriptions to shared_preferences
  _saveDescriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final descriptionsString = json.encode(_descriptions.map((key, value) {
      return MapEntry(
          key.toIso8601String(), value); // Convert DateTime to String
    }));
    await prefs.setString('descriptions', descriptionsString); // Save as JSON
  }

  // Format date to "yyyy-MM-dd"
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: Colors.grey[800],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) =>
                    isSameDay(_selectedDay, day), // Use isSameDay function
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarBuilders: CalendarBuilders(
                  // Customizing the day cell
                  defaultBuilder: (context, day, focusedDay) {
                    if (_descriptions[day] != null) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Selected Day: ${_formatDate(_selectedDay)}', // Updated date format
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              _descriptions[_selectedDay] != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transaction Name: ${_descriptions[_selectedDay]?['transactionName'] ?? 'No transaction name'}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Amount: ${_descriptions[_selectedDay]?['amount'] ?? 'No amount'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green[700],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Type: ${_descriptions[_selectedDay]?['transactionType'] ?? 'No transaction type'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No Transactions Scheduled', // Updated text
                        style: const TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ),
            ],
          ),
          if (_selectedDay != DateTime.now())
            Positioned(
              bottom: 60,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  _showDescriptionDialog(context);
                },
                backgroundColor: Colors.blue,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
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
    );
  }

  void _showDescriptionDialog(BuildContext context) {
    _transactionNameController.text =
        _descriptions[_selectedDay]?['transactionName'] ?? '';
    _transactionAmountController.text =
        _descriptions[_selectedDay]?['amount'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Description'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: _transactionType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _transactionType = newValue!;
                      });
                    },
                    items: <String>['Income', 'Expense']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  TextField(
                    controller: _transactionNameController,
                    decoration:
                        const InputDecoration(labelText: 'Transaction Name'),
                  ),
                  TextField(
                    controller: _transactionAmountController,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _descriptions[_selectedDay] = {
                    'transactionType': _transactionType,
                    'transactionName': _transactionNameController.text,
                    'amount': _transactionAmountController.text,
                  };
                });
                _saveDescriptions(); // Save data after editing
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
