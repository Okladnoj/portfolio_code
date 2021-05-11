import 'dart:convert';

import 'package:cattle_scan/api/api.dart';
import 'package:cattle_scan/views/alerts/models/alert_model.dart';
import 'package:cattle_scan/views/alerts/models/alert_model_repository.dart';
import 'package:cattle_scan/views/events_create/models/diagnose_model.dart';
import 'package:intl/intl.dart';

import 'diagnose_model_response.dart';

class DomainService {
  Future<bool> upLoadEvent(EventModel eventModel) async {
    final alertId = eventModel?.id ?? 0;
    final repositoryFeedBack = _mapToRepositoryEvent(eventModel);
    final json = repositoryFeedBack.toJson();
    // ignore: unused_local_variable
    final json1 = jsonEncode(json);
    final responseData = await CallApi.parsData('createEvent/$alertId', json);
    return responseData != null;
  }

  Future<DiagnoseModels> loadDiagnoses() async {
    final json = await CallApi.parsData('geteventcodes');
    final r = DiagnoseModelsRepository.fromJson(json as Map<String, dynamic>);

    return DiagnoseModels(_mapToListDiagnoseModel(r.data));
  }

  EventModelRepository _mapToRepositoryEvent(EventModel f) {
    return EventModelRepository(
      f.id,
      f.objectId,
      f.farmId,
      f.eventType,
      _mapToDateRepository(f.date),
      f.description,
      f.name,
      f.remark,
      f.result,
      f.daysInMilk,
      f.protocols,
      f.alerts,
    );
  }

  List<DiagnoseModel> _mapToListDiagnoseModel(List<String> data) {
    return data.map((e) => DiagnoseModel(e, e)).toList();
  }

  String _mapToDateRepository(DateTime date) {
    if (date == null) {
      return null;
    }
    final f = DateFormat('yyyy-MM-ddTHH:mm');
    return f.format(date);
  }
}
