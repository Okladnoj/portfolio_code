import 'package:cattle_scan/api/api.dart';

import '../models/alert_model.dart';
import '../models/alert_model_repository.dart';
import 'filter_model.dart';

class AlertsService {
  Future<AlertsModel> loadAlertsModel(FilterToAlerts filterToAlerts) async {
    AlertsModel alertsModel;
    dynamic postData = [];
    if (filterToAlerts.listKeys.isNotEmpty) {
      postData = filterToAlerts.listKeys;
    } else if (filterToAlerts.mapKeys.isNotEmpty) {
      postData = filterToAlerts.mapKeys;
    }

    final responseData = await CallApi.parsData(filterToAlerts.key, postData);
    if (responseData != null) {
      final r = AlertsModelRepository.fromJson(responseData as Map<String, dynamic>);
      alertsModel = AlertsModel(
        r.status,
        _mapToListAlertModel(r.data),
      );
    } else {}

    return alertsModel;
  }

  List<AlertModel> _mapToListAlertModel(List<AlertModelRepository> data) {
    return data
            ?.map((e) => AlertModel(
                  e?.id,
                  e?.bolusId,
                  e?.cowId,
                  e?.farmId,
                  e?.type,
                  e?.message,
                  e?.created,
                  e?.value,
                  _mapToEventModel(e?.event),
                  e?.farmName,
                  e?.hoursBack,
                  e?.percent,
                  _mapToListNotificationModel(e?.notifications),
                  _mapToFeedbackModel(e?.feedback),
                  e?.opened,
                ))
            ?.toList() ??
        [];
  }

  EventModel _mapToEventModel(EventModelRepository event) {
    return EventModel(
      event?.id,
      event?.objectId,
      event?.farmId,
      event?.eventType,
      _transformToDateTime(event?.date),
      event?.description,
      event?.name,
      event?.remark,
      event?.result,
      event?.daysInMilk,
      event?.protocols,
      event?.alerts,
    );
  }

  DateTime _transformToDateTime(String date) {
    DateTime dateTime;
    try {
      dateTime = DateTime?.parse(date);
    } catch (e) {
      print(e);
    }
    return dateTime;
  }

  List<NotificationModel> _mapToListNotificationModel(List<NotificationModelRepository> notifications) {
    return notifications
            ?.map((e) => NotificationModel(
                  e?.id,
                  e?.receiver,
                  e?.created,
                  e?.body,
                  e?.isRead,
                  e?.feedback,
                ))
            ?.toList() ??
        [];
  }

  FeedbackModel _mapToFeedbackModel(FeedbackModelRepository feedback) {
    return FeedbackModel(
      feedback?.id,
      _transformTimeToString(feedback?.created),
      feedback?.visualSymptoms,
      _mapToRectalTemperature(feedback?.rectalTemperature),
      _transformTimeToString(feedback?.rectalTemperatureTime),
      feedback?.treatmentNote,
      feedback?.generalNote,
      feedback?.milkDropped,
      feedback?.putToSort,
      feedback?.useful,
      feedback?.diagnosis,
    );
  }

  DateTime _transformTimeToString(String formattedString) {
    DateTime dateTime;
    try {
      dateTime = DateTime?.tryParse(formattedString);
    } catch (e) {
      print(e);
    }
    return dateTime;
  }

  Future<bool> updateReadStatusForAlert(int alertId) async {
    final dynamic postData = [alertId];
    final responseData = await CallApi.parsData('alertOpened', postData, HttpMethod.put);
    return responseData != null;
  }

  double _mapToRectalTemperature(double rectalTemperature) {
    if ((rectalTemperature ?? 0) > 0) {
      return rectalTemperature;
    } else {
      return null;
    }
  }
}
