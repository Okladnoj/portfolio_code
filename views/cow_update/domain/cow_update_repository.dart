import 'dart:convert';

import 'package:cattle_scan/api/api.dart';
import 'package:intl/intl.dart';

import '../models/cow_update_model.dart';
import '../models/cow_update_model_network.dart';

class CowUpdateRepository {
  final _f = DateFormat('yyyy-MM-dd HH:mm');
  Future<bool> updateInfo(CowUpdateModel c) async {
    bool isUpdate = false;
    final r = _mapToCowUpdateModelRepository(c);
    final apiData = r.toJson();
    final p = jsonEncode(apiData);
    final responseData = await CallApi.parsData('new_lactation', apiData, HttpMethod.post);
    if (responseData != null) {
      isUpdate = true;
    }
    return isUpdate;
  }

  CowUpdateModelRepository _mapToCowUpdateModelRepository(CowUpdateModel c) {
    return CowUpdateModelRepository(
      c?.animalId,
      c?.lactationStage,
      _f.format(c?.dateLactationStart),
    );
  }
}
