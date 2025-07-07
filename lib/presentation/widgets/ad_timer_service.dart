import 'dart:async';
import 'package:flutter/foundation.dart';

class AdTimerService extends ChangeNotifier {
  static final AdTimerService _instance = AdTimerService._internal();
  factory AdTimerService() => _instance;
  AdTimerService._internal();

  Timer? _timer;
  DateTime? _lastAdTime;
  bool _isAdDue = false;

  // Start the 30-minute timer
  void startTimer() {
    _lastAdTime = DateTime.now();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 30), (timer) {
      _isAdDue = true;
      notifyListeners();
    });
  }

  // Reset timer after showing ad
  void resetTimer() {
    _lastAdTime = DateTime.now();
    _isAdDue = false;
    notifyListeners();
  }

  // Check if ad is due
  bool get isAdDue => _isAdDue;

  // Get time since last ad
  Duration? get timeSinceLastAd {
    if (_lastAdTime == null) return null;
    return DateTime.now().difference(_lastAdTime!);
  }

  // Stop timer
  void stopTimer() {
    _timer?.cancel();
    _isAdDue = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
} 