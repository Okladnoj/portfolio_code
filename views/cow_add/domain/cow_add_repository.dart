import 'package:cattle_scan/api/api.dart';
import 'package:intl/intl.dart';

import '../models/cow_add_model.dart';
import '../models/cow_add_model_network.dart';

class CowAddRepository {
  Future<bool> createCow(CowAddModel c) async {
    bool isUpdate = false;
    final r = CowAddModelNetwork(
      _tryParse(c?.bolusId),
      _tryParse(c?.animalId),
      _formatDataToString(c?.dateOfBirth),
      c?.lactationNumber,
      c?.lactationStage,
      _formatDataToString(c?.dateLactationStart),
    );

    final apiData = r.toJson();
    final responseData = await CallApi.parsData('saveNewCow', apiData, HttpMethod.post);
    if (responseData != null) {
      isUpdate = true;
    }
    return isUpdate;
  }

  Future<CheckCow> connectBolus(CowAddModel c) async {
    CheckCow isUpdate;
    final r = CowAddModelNetwork(
      _tryParse(c?.bolusId),
      _tryParse(c?.animalId),
      _formatDataToString(c?.dateOfBirth),
      c?.lactationNumber,
      c?.lactationStage,
      _formatDataToString(c?.dateLactationStart),
    );

    final apiData = r.toJson();
    final responseData = await CallApi.parsData('checkAnimalBolusIDs', apiData);
    if (responseData != null) {
      if (responseData['data'] == 1) {
        isUpdate = CheckCow.present;
      } else {
        isUpdate = CheckCow.absent;
      }
    } else {
      isUpdate = CheckCow.error;
    }
    return isUpdate;
  }

  int _tryParse(String string) {
    try {
      return int.tryParse(string ?? '0');
    } catch (e) {
      return -1;
    }
  }

  String _formatDataToString(DateTime dateTime) {
    try {
      return _f.format(dateTime);
    } catch (e) {
      return '';
    }
  }

  final _f = DateFormat('yyyy-MM-dd HH:mm');
}
