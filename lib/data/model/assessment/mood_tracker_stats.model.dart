class MoodTrackerStatsModel {
  List<MoodCalendarDayModel>? data;
  String? dominantMood;
  double? consistency;

  MoodTrackerStatsModel({
    this.data,
    this.dominantMood,
    this.consistency,
  });

  factory MoodTrackerStatsModel.fromJson(Map<String, dynamic> json) {
    return MoodTrackerStatsModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => MoodCalendarDayModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      dominantMood: json['dominantMood'] as String?,
      consistency: (json['consistency'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
      'dominantMood': dominantMood,
      'consistency': consistency,
    };
  }
}

class MoodCalendarDayModel {
  String? date;
  String? feeling;

  MoodCalendarDayModel({
    this.date,
    this.feeling,
  });

  factory MoodCalendarDayModel.fromJson(Map<String, dynamic> json) {
    return MoodCalendarDayModel(
      date: json['date'] as String?,
      feeling: json['feeling'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'feeling': feeling,
    };
  }
}
