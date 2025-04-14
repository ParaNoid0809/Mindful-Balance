class MoodEntry {
  final DateTime date;
  final String mood;
  final String? reflection;
  final String userId;
  
  MoodEntry({
    required this.date, 
    required this.mood, 
    this.reflection, 
    required this.userId,
  });
  
  // For converting to/from JSON (will be useful for Firebase later)
  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'mood': mood,
      'reflection': reflection,
      'userId': userId,
    };
  }
  
  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      mood: json['mood'],
      reflection: json['reflection'],
      userId: json['userId'],
    );
  }
}