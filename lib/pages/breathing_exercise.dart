import 'package:flutter/material.dart';
import 'dart:async';

class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage({super.key});

  @override
  State<BreathingExercisePage> createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _timer;
  int _remainingSeconds = 60; // 1 minute
  bool _isExerciseStarted = false;
  String _breathingPhase = "Get Ready";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(
        seconds: 8,
      ), // 4 seconds inhale, 4 seconds exhale
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _breathingPhase = "Exhale...";
        });
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _breathingPhase = "Inhale...";
        });
        _animationController.forward();
      }
    });
  }

  void _startExercise() {
    setState(() {
      _isExerciseStarted = true;
      _breathingPhase = "Inhale...";
    });
    _animationController.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _stopExercise();
        }
      });
    });
  }

  void _stopExercise() {
    _timer?.cancel();
    _animationController.stop();
    setState(() {
      _isExerciseStarted = false;
      _remainingSeconds = 60;
      _breathingPhase = "Get Ready";
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1-Minute Breathing Exercise'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_isExerciseStarted) {
              _stopExercise();
            }
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _breathingPhase,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 40),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: 200 * _animation.value,
                    height: 200 * _animation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.3),
                    ),
                    child: Center(
                      child: Container(
                        width: 100 * _animation.value,
                        height: 100 * _animation.value,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Text(
                _formatTime(_remainingSeconds),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 40),
              if (!_isExerciseStarted)
                ElevatedButton(
                  onPressed: _startExercise,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Start', style: TextStyle(fontSize: 20)),
                )
              else
                ElevatedButton(
                  onPressed: _stopExercise,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Stop', style: TextStyle(fontSize: 20)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
