import 'package:flutter/material.dart';
import 'package:mindfulbalance/pages/breathing_exercise.dart';
import 'package:mindfulbalance/pages/meditation_music.dart';
import 'package:mindfulbalance/pages/log_mood.dart';

class MindfulnessPage extends StatelessWidget {
  const MindfulnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mindfulness Hub',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 24),
              _buildFeatureCard(
                context,
                title: 'Quick Meditation',
                description:
                    'Almost everything will work again if you unplug it for a few minutes, including you.',
                buttonText: 'Start',
                icon: Icons.self_improvement,
                color: Color(0xFFFCE4EC),
                darkColor: Color(0xFF4A2737),
                onPressed: () {
                  // Handle meditation start
                },
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                context,
                title: 'Breathing Exercise',
                description:
                    'A quick 1-minute breathing exercise to reset your mind.',
                buttonText: 'Start',
                icon: Icons.air,
                color: Color(0xFFE3F2FD),
                darkColor: Color(0xFF1A2C3D),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BreathingExercisePage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                context,
                title: 'Meditation Music',
                description:
                    'Calming sounds to help you relax and focus on your meditation practice.',
                buttonText: 'Browse Tracks',
                icon: Icons.music_note,
                color: Color(0xFFF3E5F5),
                darkColor: Color(0xFF3D2A45),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MeditationMusicPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                context,
                title: 'How are you feeling?',
                description:
                    'Track your mood and emotional well-being throughout the day.',
                buttonText: 'Log Mood',
                icon: Icons.mood,
                color: Color(0xFFE8F5E9),
                darkColor: Color(0xFF1F3320),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogMoodPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required String buttonText,
    required IconData icon,
    required Color color,
    required Color darkColor,
    required VoidCallback onPressed,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? darkColor : color;
    final textColor =
        isDark ? Theme.of(context).colorScheme.onBackground : Colors.black87;

    return Card(
      elevation: 2,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: textColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: textColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.9),
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
