import 'package:cattle_scan/views/alerts/domain/filter_model.dart';
import 'package:cattle_scan/views/alerts/domain/load_data.dart';
import 'package:cattle_scan/views/alerts/models/alert_model.dart';

Future<AlertsModel> getAlertsData(int bolusId) async {
  final _filterToAlerts = FilterToAlerts(listKeys: [
    '$bolusId',
    '0',
  ]);
  return AlertsService().loadAlertsModel(_filterToAlerts);
}
