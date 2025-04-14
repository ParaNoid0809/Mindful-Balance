import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mood_entry.dart';

class MoodTrendsChart extends StatelessWidget {
  final List<MoodEntry> moodEntries;
  
  const MoodTrendsChart({super.key, required this.moodEntries});

  @override
  Widget build(BuildContext context) {
    // Sort entries by date
    final sortedEntries = List<MoodEntry>.from(moodEntries)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Convert mood emojis to numeric values for the chart
    List<FlSpot> spots = [];
    for (int i = 0; i < sortedEntries.length; i++) {
      final entry = sortedEntries[i];
      // Convert emoji to a number for plotting
      double moodValue;
      switch (entry.mood) {
        case '😀': moodValue = 5; break;
        case '😐': moodValue = 3; break;
        case '😢': moodValue = 1; break;
        case '😠': moodValue = 2; break;
        case '😴': moodValue = 4; break;
        default: moodValue = 3;
      }
      
      spots.add(FlSpot(i.toDouble(), moodValue));
    }

    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Mood Trends',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              // Only show some date labels to avoid crowding
                              if (value.toInt() % 3 != 0) {
                                return const SizedBox.shrink();
                              }
                              
                              final index = value.toInt();
                              if (index >= 0 && index < sortedEntries.length) {
                                final date = sortedEntries[index].date;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '${date.month}/${date.day}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              String emoji;
                              switch (value.toInt()) {
                                case 1: emoji = '😢'; break;
                                case 2: emoji = '😠'; break;
                                case 3: emoji = '😐'; break;
                                case 4: emoji = '😴'; break;
                                case 5: emoji = '😀'; break;
                                default: return const SizedBox.shrink();
                              }
                              
                              return Text(
                                emoji,
                                style: const TextStyle(fontSize: 14),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.deepPurple,
                          barWidth: 3,
                          belowBarData: BarAreaData(
                            show: true,
                            // ignore: deprecated_member_use
                            color: Colors.deepPurple.withOpacity(0.2),
                          ),
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                      minY: 0.5,
                      maxY: 5.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.info_outline, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      'Tap on a data point to see details',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}