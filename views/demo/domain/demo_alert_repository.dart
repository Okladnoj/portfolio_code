import 'package:cattle_scan/api/api.dart';

import '../models/demo_alert_model.dart';

class CowUpdateRepository {
  Future<DemoAlertModel> updateInfo() async {
    bool isUpdate = false;

    final responseData = await CallApi.parsData('requestactivation');
    if (responseData != null) {
      isUpdate = true;
    }
    return DemoAlertModel(isUpdate);
  }
}
