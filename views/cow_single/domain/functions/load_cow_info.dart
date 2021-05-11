import 'package:cattle_scan/api/api.dart';

Future<Map<String, String>> getInfo(int bolusId) async {
  final Map<String, String> info = {};
  final List<dynamic> apiData = [
    bolusId,
  ];
  final responseData = await CallApi.parsData('cowDetails', apiData);
  try {
    if (responseData != null) {
      info['lactationStage'] = responseData['data']['current_stage_of_lactation'] as String;
      info['daysInMilk'] = responseData['data']['lactation_day'].toString();
      info['currentLactation'] = responseData['data']['current_lactation'].toString();
      info['due'] = responseData['data']['due'].toString();
    }
  } catch (e) {
    print(e);
  }
  return info;
}
