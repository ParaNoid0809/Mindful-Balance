import 'package:flutter/material.dart';
import 'package:mindfulbalance/services/mood_service.dart';

class LogMoodPage extends StatefulWidget {
  const LogMoodPage({super.key});

  @override
  State<LogMoodPage> createState() => _LogMoodPageState();
}

class _LogMoodPageState extends State<LogMoodPage> {
  final _textController = TextEditingController();
  final _moodService = MoodService();
  bool _isLoading = false;
  String? _predictedMood;
  String? _errorMessage;
  double _confidence = 0.0;
  String? _apiResponse;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _predictMood() async {
    if (_textController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter some text about your day';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('Attempting to predict mood with text: ${_textController.text}');
      final result = await _moodService.predictMood(
        _textController.text.trim(),
      );
      print('API Response: $result');

      if (result.containsKey('error')) {
        setState(() {
          _errorMessage = result['error'];
          _isLoading = false;
        });
        return;
      }

      setState(() {
        // The API returns mood_label and confidence
        _predictedMood = result['mood_label']?.toString().toLowerCase();
        _confidence = (result['confidence'] ?? 0.0).toDouble();
        _isLoading = false;
        _errorMessage = null;
        _apiResponse = result.toString();
      });
    } catch (e) {
      print('Error predicting mood: $e');
      setState(() {
        _errorMessage = 'Unable to analyze mood. Please try again.';
        _isLoading = false;
      });
    }
  }

  String _getEmojiForMood(String? mood) {
    switch (mood?.toLowerCase()) {
      case 'happy':
        return '😊';
      case 'sad':
        return '😢';
      case 'angry':
        return '😠';
      case 'neutral':
        return '😐';
      case 'anxious':
        return '😰';
      default:
        return '🤔';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Log Your Mood',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 0,
                  color:
                      isDark
                          ? const Color(0xFF1A2C3D)
                          : const Color(0xFFE3F2FD),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How was your day?',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Share your thoughts and feelings, and our AI will help identify your mood',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onBackground.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _textController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Type about your day...',
                            filled: true,
                            fillColor:
                                isDark
                                    ? Colors.black12
                                    : Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _predictMood,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text('Analyze Mood'),
                          ),
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (_predictedMood != null) ...[
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    color:
                        isDark
                            ? const Color(0xFF4A2737)
                            : const Color(0xFFFCE4EC),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Mood Analysis',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                _getEmojiForMood(_predictedMood),
                                style: const TextStyle(fontSize: 48),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _predictedMood!,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineSmall?.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onBackground,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Confidence: ${(_confidence * 100).toStringAsFixed(1)}%',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (_apiResponse != null) ...[
                  const SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'API Response: $_apiResponse',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
