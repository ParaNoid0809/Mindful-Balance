import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: constraints.maxWidth > 600 ? 1.5 : 1.35,
                      children: [
                        InfoCard(
                          title: "Today's Screen Time",
                          value: "5h 20m",
                          icon: Icons.timer,
                          trend: "+2h vs yesterday",
                          trendUp: false,
                          color: const Color(0xFFFCE4EC),
                          darkColor: const Color(0xFF4A2737),
                        ),
                        InfoCard(
                          title: "Mindfulness Minutes",
                          value: "45m",
                          icon: Icons.self_improvement,
                          trend: "+15m vs yesterday",
                          trendUp: true,
                          color: const Color(0xFFE3F2FD),
                          darkColor: const Color(0xFF1A2C3D),
                        ),
                        InfoCard(
                          title: "Mood Score",
                          value: "8.5",
                          icon: Icons.mood,
                          trend: "Excellent",
                          trendUp: true,
                          color: const Color(0xFFF3E5F5),
                          darkColor: const Color(0xFF3D2A45),
                        ),
                        InfoCard(
                          title: "Focus Sessions",
                          value: "6",
                          icon: Icons.center_focus_strong,
                          trend: "2 more than usual",
                          trendUp: true,
                          color: const Color(0xFFE8F5E9),
                          darkColor: const Color(0xFF1F3320),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Card(
                  color:
                      isDark
                          ? const Color(0xFF1A2C3D)
                          : const Color(0xFFE3F2FD),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Weekly Activity',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                isDark
                                    ? Theme.of(context).colorScheme.onBackground
                                    : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: TextStyle(
                                          color:
                                              isDark
                                                  ? Colors.white70
                                                  : Colors.black54,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const days = [
                                        'Mon',
                                        'Tue',
                                        'Wed',
                                        'Thu',
                                        'Fri',
                                        'Sat',
                                        'Sun',
                                      ];
                                      if (value >= 0 && value < days.length) {
                                        return Text(
                                          days[value.toInt()],
                                          style: TextStyle(
                                            color:
                                                isDark
                                                    ? Colors.white70
                                                    : Colors.black54,
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: const [
                                    FlSpot(0, 3),
                                    FlSpot(1, 4),
                                    FlSpot(2, 3.5),
                                    FlSpot(3, 5),
                                    FlSpot(4, 4),
                                    FlSpot(5, 6),
                                    FlSpot(6, 5.5),
                                  ],
                                  isCurved: true,
                                  color: Theme.of(context).colorScheme.primary,
                                  barWidth: 3,
                                  dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String trend;
  final bool trendUp;
  final Color color;
  final Color darkColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.trend,
    required this.trendUp,
    required this.color,
    required this.darkColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? darkColor : color;
    final textColor =
        isDark ? Theme.of(context).colorScheme.onBackground : Colors.black87;

    return Card(
      elevation: 2,
      color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              children: [
                Icon(icon, color: textColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: trendUp ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    trend,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: trendUp ? Colors.green : Colors.red,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
