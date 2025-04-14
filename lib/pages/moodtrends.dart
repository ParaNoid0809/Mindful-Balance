import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../providers/mood_data_provider.dart';
import '../widgets/mood_trends_chart.dart';

class MoodTrendsPage extends StatelessWidget {
  const MoodTrendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get dummy data from provider
    final moodDataProvider = MoodDataProvider();
    final moodEntries = moodDataProvider.getDummyMoodData();

    return Scaffold(
      appBar: AppBar(title: const Text('Mood Trends')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Our mood trend chart
            MoodTrendsChart(moodEntries: moodEntries),

            const SizedBox(height: 24),

            // Mood distribution summary
            _buildMoodDistribution(moodEntries),

            const SizedBox(height: 24),

            // Recent entries
            _buildRecentEntries(moodEntries),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodDistribution(List<MoodEntry> entries) {
    // Count occurrences of each mood
    final Map<String, int> moodCounts = {};
    for (var entry in entries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mood Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),

            // Simple horizontal bars showing distribution
            ...moodCounts.entries.map((entry) {
              final percentage = (entry.value / entries.length) * 100;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text(entry.key, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: entry.value / entries.length,
                            child: Container(
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
              // ignore: unnecessary_to_list_in_spreads
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentEntries(List<MoodEntry> entries) {
    // Take the most recent 5 entries
    final recentEntries =
        List<MoodEntry>.from(entries)
          ..sort((a, b) => b.date.compareTo(a.date))
          ..take(5);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Check-ins',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            ...recentEntries.map((entry) {
              return ListTile(
                leading: Text(entry.mood, style: const TextStyle(fontSize: 24)),
                title: Text(entry.reflection ?? ''),
                subtitle: Text(
                  '${entry.date.month}/${entry.date.day}/${entry.date.year}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              );
              // ignore: unnecessary_to_list_in_spreads
            }).toList(),
          ],
        ),
      ),
    );
  }
}
