import 'package:intl/intl.dart';

class AppDateUtils {
  // Format date for display (e.g., "Today", "Tomorrow", or formatted date)
  static String formatDateForDisplay(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    
    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return 'Today';
    } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return 'Tomorrow';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE, d MMM').format(date);
    }
  }
  
  // Format time for display
  static String formatTimeForDisplay(String timeString) {
    try {
      // Convert 24-hour format to 12-hour format
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      final timeOfDay = TimeOfDay(hour: hour, minute: minute);
      return formatTimeOfDay(timeOfDay);
    } catch (e) {
      return timeString;
    }
  }
  
  // Format TimeOfDay object for display
  static String formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    
    return '$hour:$minute $period';
  }
  
  // Get a list of dates for the date picker (7 days before and after today)
  static List<DateTime> getDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateRange = <DateTime>[];
    
    // Add 7 days before today
    for (int i = 7; i > 0; i--) {
      dateRange.add(today.subtract(Duration(days: i)));
    }
    
    // Add today
    dateRange.add(today);
    
    // Add 7 days after today
    for (int i = 1; i <= 7; i++) {
      dateRange.add(today.add(Duration(days: i)));
    }
    
    return dateRange;
  }
  
  // Format date as ISO8601 string (YYYY-MM-DD)
  static String formatDateToISO(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  
  // Calculate match time status display (e.g., "15 mins ago", "Starts in 2 hrs")
  static String calculateTimeStatus(String dateString, String timeString) {
    try {
      final date = DateTime.parse(dateString);
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      final matchDateTime = DateTime(date.year, date.month, date.day, hour, minute);
      final now = DateTime.now();
      final difference = matchDateTime.difference(now);
      
      if (difference.inMinutes > 0) {
        // Match is in the future
        if (difference.inHours > 0) {
          return 'Starts in ${difference.inHours} ${difference.inHours == 1 ? 'hr' : 'hrs'}';
        } else {
          return 'Starts in ${difference.inMinutes} ${difference.inMinutes == 1 ? 'min' : 'mins'}';
        }
      } else {
        // Match is in the past
        if (difference.inHours.abs() > 0) {
          return '${difference.inHours.abs()} ${difference.inHours.abs() == 1 ? 'hr' : 'hrs'} ago';
        } else {
          return '${difference.inMinutes.abs()} ${difference.inMinutes.abs() == 1 ? 'min' : 'mins'} ago';
        }
      }
    } catch (e) {
      return '';
    }
  }
}

// Custom time of day class to avoid Flutter dependency
class TimeOfDay {
  final int hour;
  final int minute;
  
  const TimeOfDay({required this.hour, required this.minute});
  
  DayPeriod get period => hour < 12 ? DayPeriod.am : DayPeriod.pm;
  
  int get hourOfPeriod => hour % 12;
}

enum DayPeriod { am, pm }
