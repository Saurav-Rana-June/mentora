class TimeSlot {
  final String time;
  final String period; // 'Morning', 'Afternoon', 'Evening'
  final bool isAvailable;

  TimeSlot({required this.time, required this.period, this.isAvailable = true});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      time: json['time'] as String,
      period: json['period'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }
}
