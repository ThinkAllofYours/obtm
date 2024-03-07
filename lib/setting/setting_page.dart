import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SettingPage extends StatefulWidget {
  final Function(int, int) onGoalTimeUpdated;

  const SettingPage({super.key, required this.onGoalTimeUpdated});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late Future<void> _loadGoalTimeFuture;
  int _selectedMinutes = 0;
  int _selectedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _loadGoalTimeFuture = _loadGoalTime();
  }

  Future<void> _loadGoalTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedMinutes = prefs.getInt('goalTimeMinutes') ?? 0;
    _selectedSeconds = prefs.getInt('goalTimeSeconds') ?? 0;
  }

  Future<void> _saveGoalTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('goalTimeMinutes', _selectedMinutes);
    await prefs.setInt('goalTimeSeconds', _selectedSeconds);
    widget.onGoalTimeUpdated(_selectedMinutes, _selectedSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<void>(
        future: _loadGoalTimeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildUI();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildUI() {
    double fontSize = MediaQuery.of(context).size.width > 600 ? 28 : 21;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Text(
              "Goal Time",
              style: TextStyle(
                fontSize: fontSize,
                color: const Color(0xFF111340),
              ),
            ),
            SizedBox(height: 200, child: _buildTimePickers(fontSize)),
            ElevatedButton(
              onPressed: _saveGoalTime,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickers(double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _buildPicker(_selectedMinutes, 'min', fontSize),
        ),
        Expanded(
          child: _buildPicker(_selectedSeconds, 'sec', fontSize),
        ),
      ],
    );
  }

  Widget _buildPicker(int initialValue, String suffix, double fontSize) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: initialValue),
      itemExtent: 48.0,
      onSelectedItemChanged: (int value) {
        setState(() {
          if (suffix == 'min') {
            _selectedMinutes = value;
          } else {
            _selectedSeconds = value;
          }
        });
      },
      children: List<Widget>.generate(60, (int index) {
        return Center(
          child: Text(
            '$index $suffix',
            style: TextStyle(
              fontSize: fontSize,
              color: const Color(0xFF111340),
            ),
          ),
        );
      }),
    );
  }
}
