import 'package:flutter/material.dart';

class AnalyticsController extends ChangeNotifier {
  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime endDate = DateTime.now();
  int touchedIndex = -1;

  void setDateRange(DateTime start, DateTime end) {
    startDate = start;
    endDate = end;
    touchedIndex = -1;
    notifyListeners();
  }

  void setTouchedIndex(int index) {
    if (touchedIndex != index) {
      touchedIndex = index;
      notifyListeners();
    }
  }

  Future<void> pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setDateRange(picked.start, picked.end);
    }
  }
}
