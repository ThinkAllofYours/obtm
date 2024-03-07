import 'dart:async';

class TimerController {
  Timer? _timer;
  DateTime? _startTime;
  int _milliseconds = 0; // 경과 시간을 밀리초 단위로 저장
  Function(int)? onTick;
  final List<String> tapTimes = [];

  static final TimerController _instance = TimerController._internal();

  factory TimerController() => _instance;

  TimerController._internal();

  bool get isRunning => _timer?.isActive ?? false;

  // 현재 경과 시간을 계산
  int get currentMilliseconds => _startTime != null ? DateTime.now().difference(_startTime!).inMilliseconds : _milliseconds;

  void startTimer() {
    _startTime = DateTime.now(); // 시작 시간을 기록
    _timer?.cancel(); // 현재 동작 중인 타이머가 있다면 취소
    _timer = Timer.periodic(const Duration(milliseconds: 75), (timer) {
      // 타이머가 실행될 때마다 경과 시간을 업데이트
      _milliseconds = currentMilliseconds;
      if (onTick != null) {
        onTick!(_milliseconds);
      }
    });
  }

  void stopAndResetTimer() {
    _timer?.cancel(); // 타이머를 중지
    _milliseconds = currentMilliseconds; // 마지막 경과 시간을 저장
    _startTime = null; // 시작 시간을 리셋
    if (onTick != null) {
      onTick!(0);
    }
  }

  void logTime() {
    final int seconds = _milliseconds ~/ 1000;
    final int minutes = seconds ~/ 60;
    final int displaySeconds = seconds % 60;
    final int displayMilliseconds = (_milliseconds ~/ 10 % 100);

    final String formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${displaySeconds.toString().padLeft(2, '0')}.${displayMilliseconds.toString().padLeft(2, '0')}';

    tapTimes.insert(0, formattedTime);
  }

  void clearTapTimes() {
    tapTimes.clear();
  }

  void dispose() {
    _timer?.cancel();
  }
}
