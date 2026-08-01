enum DateFilter {
  thisWeek('This Week'),
  thisMonth('This Month'),
  lastMonth('Last Month'),
  last3Month('Last 3 Month'),
  last6Month('Last 6 Month'),
  thisYear('This Year'),
  lastYear('Last Year'),
  allTime('All Time');

  final String value;
  const DateFilter(this.value);

  @override
  String toString() => value;
}
