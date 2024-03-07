import 'package:flutter/material.dart';
import 'timer_controller.dart';

class TimerPage extends StatefulWidget {
  final int goalTimeInSeconds;

  const TimerPage({super.key, required this.goalTimeInSeconds});

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with WidgetsBindingObserver {
  final TimerController _timerController = TimerController();
  bool _isRunning = false;
  int _milliseconds = 0;

  @override
  void initState() {
    super.initState();
    //Observer를 추가
    WidgetsBinding.instance.addObserver(this);
    _timerController.onTick = (milliseconds) {
      setState(() {
        _milliseconds = milliseconds;
      });
    };
    //타이머의 현재 상태를 반영
    _milliseconds = _timerController.currentMilliseconds;
    _isRunning = _timerController.isRunning;
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timerController.logTime();
      _timerController.stopAndResetTimer();
    } else {
      _timerController.startTimer();
    }
    _isRunning = !_isRunning;
  }

  void _clearList() {
    setState(() {
      _timerController.clearTapTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final int goalTimeInMillis = widget.goalTimeInSeconds * 1000;
    double progress = (_milliseconds / goalTimeInMillis).clamp(0.0, 1.0);

    final int seconds = (_milliseconds / 1000).floor();
    final int minutes = seconds ~/ 60;
    final int displaySeconds = seconds % 60;
    final int displayMilliseconds = (_milliseconds / 10).floor() % 100;
    final String formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${displaySeconds.toString().padLeft(2, '0')}.${displayMilliseconds.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white,),
            onPressed: _clearList,
            tooltip: 'Clear List',
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _toggleTimer,
            child: Text(
              formattedTime,
              style: const TextStyle(
                fontSize: 70,
                color: Color(0xFFB17CEF),
                fontFamily: 'Courier',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFB1DC0C),
              color: const Color(0xFFB17CEF),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _timerController.tapTimes.length,
              itemBuilder: (context, index) {
                int orderNumber = _timerController.tapTimes.length - index;
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ListTile(
                    title: Text(
                      _timerController.tapTimes[index],
                      style: const TextStyle(
                        fontSize: 30,
                        color: Color(0xFF111340), // Dark blue
                      ),
                    ),
                    trailing: Text(
                      "#$orderNumber",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Color(0xFFB17CEF),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Observer를 제거
    WidgetsBinding.instance.removeObserver(this);
    _timerController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // 앱이나 페이지가 다시 활성화될 때 타이머 상태를 업데.
      setState(() {
        _milliseconds = _timerController.currentMilliseconds;
        _isRunning = _timerController.isRunning;
      });
    }
  }
}