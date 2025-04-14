import '../models/mood_entry.dart';

class MoodDataProvider {
  // Singleton pattern
  static final MoodDataProvider _instance = MoodDataProvider._internal();
  factory MoodDataProvider() => _instance;
  MoodDataProvider._internal();
  
  // For now, we'll use a hardcoded user ID
  final String userId = 'user_1';
  
  // Generate dummy data for past 14 days
  List<MoodEntry> getDummyMoodData() {
    final now = DateTime.now();
    final twoWeeksAgo = now.subtract(const Duration(days: 14));
    
    List<MoodEntry> entries = [];
    List<String> moods = ['😀', '😐', '😢', '😠', '😴'];
    
    for (int i = 0; i < 14; i++) {
      final date = twoWeeksAgo.add(Duration(days: i));
      final randomMoodIndex = i % moods.length;  // This creates a repeating pattern
      
      entries.add(
        MoodEntry(
          date: date,
          mood: moods[randomMoodIndex],
          reflection: 'Reflection for day ${i+1}',
          userId: userId,
        )
      );
    }
    
    return entries;
  }
}