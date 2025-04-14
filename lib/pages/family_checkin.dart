import 'package:flutter/material.dart';

class FamilyCheckInPage extends StatefulWidget {
  const FamilyCheckInPage({super.key});

  @override
  State<FamilyCheckInPage> createState() => _FamilyCheckInPageState();
}

class _FamilyCheckInPageState extends State<FamilyCheckInPage> {
  int? _selectedMoodIndex;
  final _textController = TextEditingController();
  bool _isSubmitting = false;

  final List<MoodOption> _moods = [
    MoodOption(emoji: '😊', label: 'Great', color: Colors.green),
    MoodOption(emoji: '😐', label: 'Okay', color: Colors.blue),
    MoodOption(emoji: '😢', label: 'Sad', color: Colors.purple),
    MoodOption(emoji: '😠', label: 'Angry', color: Colors.red),
    MoodOption(emoji: '😴', label: 'Tired', color: Colors.grey),
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitCheckIn() {
    if (_selectedMoodIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a mood first')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isSubmitting = false);
        _showSuccessDialog();
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 50,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                Text(
                  'Check-In Submitted!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text('Thank you for sharing how you feel.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
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
                Text(
                  'Family Check-In',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
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
                          'How are you feeling today?',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 100,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _moods.length,
                            separatorBuilder:
                                (context, index) => const SizedBox(width: 16),
                            itemBuilder:
                                (context, index) => _buildMoodOption(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                          'Share your thoughts',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _textController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText:
                                'How was your day? Share your experiences...',
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
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitCheckIn,
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
                                _isSubmitting
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text('Submit Check-In'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_selectedMoodIndex != null) ...[
                  Text(
                    "Today's Reflection",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    color:
                        isDark
                            ? const Color(0xFF3D2A45)
                            : const Color(0xFFF3E5F5),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _moods[_selectedMoodIndex!].emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _moods[_selectedMoodIndex!].label,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onBackground,
                                ),
                              ),
                            ],
                          ),
                          if (_textController.text.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              _textController.text,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ],
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

  Widget _buildMoodOption(int index) {
    final isSelected = _selectedMoodIndex == index;
    final mood = _moods[index];

    return GestureDetector(
      onTap: () => setState(() => _selectedMoodIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? mood.color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? mood.color : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mood.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              mood.label,
              style: TextStyle(
                color:
                    isSelected
                        ? mood.color
                        : Theme.of(context).colorScheme.onBackground,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodOption {
  final String emoji;
  final String label;
  final Color color;

  const MoodOption({
    required this.emoji,
    required this.label,
    required this.color,
  });
}
