import 'package:cattle_scan/api/api.dart';
import 'package:intl/intl.dart';

Future<String> getWaterIntakeData(String period, int bolusId) async {
  final f = DateFormat('yyyy-MM-dd HH:mm');
  String _waterIntakesData;
  List<dynamic> apiData;

  final DateTime currentDate = DateTime.now();

  if (period == 'today') {
    final DateTime todayDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      currentDate.hour,
      currentDate.minute,
      currentDate.second,
    );

    final DateTime yesterdayDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day - 1,
      currentDate.hour,
      currentDate.minute,
      currentDate.second,
    );

    apiData = [
      bolusId,
      f.format(yesterdayDate),
      f.format(todayDate),
    ];
  } else {
    // Week
    final DateTime weekDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day - 7,
      currentDate.hour,
      currentDate.minute,
      currentDate.second,
    );

    apiData = [
      bolusId,
      f.format(weekDate),
      f.format(currentDate),
    ];
  }

  try {
    final responseData = await CallApi.parsData('getSumWaterIntakesForCow', apiData);
    if (responseData != null) {
      _waterIntakesData = double.tryParse(responseData['data'].toString()).toStringAsFixed(2);
    } else {
      // Error
    }
  } catch (e) {
    print(e);
  }
  return _waterIntakesData;
}
