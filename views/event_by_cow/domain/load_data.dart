import 'package:cattle_scan/api/api.dart';
import 'package:cattle_scan/views/alerts/models/alert_model.dart';
import 'package:cattle_scan/views/alerts/models/alert_model_repository.dart';

import '../models/cow_event_model.dart';
import '../models/cow_event_model_repository.dart';

class EventsService {
  Future<EventsModel> loadEventsModel(int bolusId) async {
    EventsModel eventsModel;
    final dynamic postData = ['${bolusId ?? 0}'];

    final responseData = await CallApi.parsData('listEventsByBolusId', postData);
    if (responseData != null) {
      final r = EventsModelRepository.fromJson(responseData as Map<String, dynamic>);
      eventsModel = EventsModel(
        r.status,
        _mapToListEventModel(r.events),
      );
    } else {}

    return eventsModel;
  }

  List<EventFullModel> _mapToListEventModel(List<EventFullModelRepository> events) {
    return events
            ?.map((e) => EventFullModel(
                  e?.id,
                  e?.objectId,
                  e?.farmId,
                  e?.eventType,
                  _transformToDateTime(e?.date),
                  e?.description,
                  e?.name,
                  e?.remark,
                  e?.result,
                  e?.daysInMilk,
                  e?.protocols,
                  _mapToListAlertModel(e?.alerts),
                ))
            ?.toList() ??
        [];
  }

  List<AlertModel> _mapToListAlertModel(List<AlertModelRepository> alerts) {
    return alerts
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

  double _mapToRectalTemperature(double rectalTemperature) {
    if ((rectalTemperature ?? 0) > 0) {
      return rectalTemperature;
    } else {
      return null;
    }
  }
}
