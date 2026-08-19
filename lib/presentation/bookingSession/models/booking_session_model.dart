class TimeSlot {
  final String time;
  final String period; // 'Morning', 'Afternoon', 'Evening'
  final bool isAvailable;

  TimeSlot({required this.time, required this.period, this.isAvailable = true});
}
