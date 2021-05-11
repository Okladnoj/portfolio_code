import 'dart:convert';

import 'package:cattle_scan/api/api.dart';
import 'package:cattle_scan/views/alerts/models/alert_model.dart';
import 'package:cattle_scan/views/alerts/models/alert_model_repository.dart';
import 'package:intl/intl.dart';

class DomainService {
  Future<bool> upLoadFeedback(FeedbackModel feedBackModel) async {
    final repositoryFeedBack = _mapToRepositoryFeedBack(feedBackModel);
    final json = repositoryFeedBack.toJson();
    // ignore: unused_local_variable
    final json1 = jsonEncode(json);
    final responseData = await CallApi.parsData('saveFeedback', json);
    return responseData != null;
  }

  FeedbackModelRepository _mapToRepositoryFeedBack(FeedbackModel f) {
    return FeedbackModelRepository(
      f.id,
      _mapToDateRepository(f.created),
      f.visualSymptoms,
      _mapToRectalTemperature(f.rectalTemperature),
      _mapToDateRepository(f.rectalTemperatureTime),
      f.treatmentNote,
      f.generalNote,
      f.milkDropped,
      f.putToSort,
      f.useful,
      f.diagnosis,
    );
  }

  String _mapToDateRepository(DateTime date) {
    if (date == null) {
      return null;
    }
    final f = DateFormat('yyyy-MM-ddTHH:mm');
    return f.format(date);
  }

  double _mapToRectalTemperature(double rectalTemperature) {
    if ((rectalTemperature ?? 0) > 0) {
      return rectalTemperature;
    } else {
      return null;
    }
  }
}
