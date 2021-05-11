import 'package:cattle_scan/api/api.dart';

import '../models/sing_up_model.dart';
import '../models/sing_up_model_network.dart';

class SingUpRepository {
  Future<bool> createFarm(SingUpModel m) async {
    bool isUpdate = false;
    final n = _mapToSingUpModelNetwork(m);

    final responseData = await CallApi.parsData('createFarm', [], HttpMethod.post);
    if (responseData != null) {
      isUpdate = true;
    }
    return isUpdate;
  }

  SingUpModelNetwork _mapToSingUpModelNetwork(SingUpModel m) {
    return SingUpModelNetwork(
      m?.nameFarm,
      m?.nameFarmer,
      m?.email,
      m?.password,
    );
  }
}
