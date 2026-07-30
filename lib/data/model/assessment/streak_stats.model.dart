class StreakStatsModel {
  final int currentStreak;
  final int weeklyCheckInCount;

  StreakStatsModel({
    required this.currentStreak,
    required this.weeklyCheckInCount,
  });

  factory StreakStatsModel.fromJson(Map<String, dynamic> json) {
    return StreakStatsModel(
      currentStreak: json['current_streak'] as int,
      weeklyCheckInCount: json['weekly_checkin_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_streak': currentStreak,
      'weekly_checkin_count': weeklyCheckInCount,
    };
  }
}
