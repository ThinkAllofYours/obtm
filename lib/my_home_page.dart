import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obtm/timer/notification.dart';
import 'timer/timer_page.dart';
import 'setting/setting_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  int goalTimeInSeconds = 60; // 초깃값을 1분(60초)으로 설정
  final notificationService = NotificationService();

  @override
  void initState() {
    super.initState();

    notificationService.init();
    // 모바일 환경에서는 세로 모드 고정
    _setPreferredOrientations();
  }

  // 화면 방향 설정
  void _setPreferredOrientations() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _updateGoalTime(int minutes, int seconds) {
    final int totalSeconds = (minutes * 60) + seconds;
    setState(() {
      goalTimeInSeconds = totalSeconds;
      selectedIndex = 1; // TimerPage로 자동으로 넘어감
    });
  }

  @override
  Widget build(BuildContext context) {
    // 화면 크기에 따라 가로/세로 모드 결정
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final isLargeScreen = MediaQuery.of(context).size.width >= 600;

    // 태블릿 또는 더 큰 화면에서만 가로 모드 허용
    if (!isPortrait && isLargeScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      _setPreferredOrientations();
    }

    Widget page = selectedIndex == 0
        ? SettingPage(onGoalTimeUpdated: _updateGoalTime)
        : TimerPage(goalTimeInSeconds: goalTimeInSeconds);

    return Scaffold(
      body: isLargeScreen ? _buildWideLayout(page) : _buildNarrowLayout(page),
    );
  }

  Widget _buildNarrowLayout(Widget page) {
    return Column(
      children: [
        Expanded(child: page),
        _buildBottomNavigationBar(),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer),
          label: 'Timer',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (value) => setState(() => selectedIndex = value),
    );
  }

  Widget _buildWideLayout(Widget page) {
    return Row(
      children: [
        _buildNavigationRail(),
        Expanded(child: page),
      ],
    );
  }

  NavigationRail _buildNavigationRail() {
    return NavigationRail(
      extended: MediaQuery.of(context).size.width >= 600,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.timer),
          label: Text('Timer'),
        ),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: (value) => setState(() => selectedIndex = value),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]); // 앱이 종료될 때 화면 방향 제한을 해제합니다.
    super.dispose();
  }
}
