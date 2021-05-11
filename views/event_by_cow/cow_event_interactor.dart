import 'dart:async';

import 'package:cattle_scan/components/logic/text_format.dart';
import 'package:cattle_scan/views/alerts/models/alert_model.dart';
import 'package:cattle_scan/views/alerts/models/alert_model_ui.dart';
import 'package:intl/intl.dart';

import 'domain/load_data.dart';
import 'models/cow_event_model.dart';
import 'models/cow_event_model_ui.dart';

class EventsInteractor {
  EventsInteractor(int bolusId) {
    _bolusId = bolusId;
    _init();
  }

  final StreamController<EventsModelUI> _controller = StreamController.broadcast();
  StreamSink<EventsModelUI> get sink => _controller.sink;
  Stream<EventsModelUI> get observer => _controller.stream;

  EventsModel _alertsModel;
  EventsService _alertsService;
  int _bolusId;

  void _init() {
    _alertsService = EventsService();
  }

  void dispose() {
    _controller.close();
  }

  Future<void> loadEventsModel() async {
    _alertsModel = await _alertsService?.loadEventsModel(_bolusId);
    _updateUI();
  }

  Future<void> simpleUpdate() async {
    _alertsModel = await _alertsService?.loadEventsModel(_bolusId);
    _updateUI();
  }

  void _updateUI() {
    sink.add(_mapToUI());
  }

  EventsModelUI _mapToUI() {
    return EventsModelUI(
      _alertsModel?.status,
      _mapToListEventFullModelUI(_alertsModel?.events),
      _mapToListEventModelUI(_alertsModel?.events),
    );
  }

  List<EventFullModelUI> _mapToListEventFullModelUI(List<EventFullModel> events) {
    return events
            ?.map((e) => EventFullModelUI(
                  e?.id,
                  e?.objectId,
                  e?.farmId,
                  e?.eventType,
                  _mapToDateUI(e?.date),
                  e?.description,
                  e?.name,
                  e?.remark,
                  e?.result,
                  e?.daysInMilk,
                  e?.protocols,
                  _mapToListAlertModelUI(e?.alerts),
                ))
            ?.toList() ??
        [];
  }

  List<EventModelUI> _mapToListEventModelUI(List<EventFullModel> events) {
    return events
            ?.map((e) => EventModelUI(
                  e?.id,
                  e?.objectId,
                  e?.farmId,
                  e?.eventType,
                  _mapToDateUI(e?.date),
                  e?.description,
                  e?.name,
                  e?.remark,
                  e?.result,
                  e?.daysInMilk,
                  e?.protocols,
                  _mapToIntlAlerts(e?.alerts),
                ))
            ?.toList() ??
        [];
  }

  List<int> _mapToIntlAlerts(List<AlertModel> alerts) {
    return alerts?.map((e) => e?.id)?.toList();
  }

  List<AlertModelUI> _mapToListAlertModelUI(List<AlertModel> data) {
    return data
            ?.map((e) => AlertModelUI(
                  e?.id,
                  e?.bolusId,
                  e?.cowId,
                  e?.farmId,
                  e?.type,
                  gFixDegree(e?.message),
                  e?.created,
                  e?.value,
                  _mapToEventModelUI(e?.event),
                  e?.farmName,
                  e?.hoursBack,
                  e?.percent,
                  _mapToListNotificationModelUI(e?.notifications),
                  _mapToFeedbackModelUI(e?.feedback),
                  e?.opened ?? false,
                  [],
                ))
            ?.toList() ??
        [];
  }

  EventModelUI _mapToEventModelUI(EventModel event) {
    return EventModelUI(
      event.id,
      event.objectId,
      event.farmId,
      event.eventType,
      _mapToDateUI(event.date),
      event.description,
      event.name,
      event.remark,
      event.result,
      event.daysInMilk,
      event.protocols,
      event.alerts,
    );
  }

  List<NotificationModelUI> _mapToListNotificationModelUI(List<NotificationModel> notifications) {
    return notifications
            ?.map((e) => NotificationModelUI(
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

  FeedbackModelUI _mapToFeedbackModelUI(FeedbackModel feedback) {
    return FeedbackModelUI(
      feedback?.id,
      _mapToDateRepository(feedback?.created),
      feedback?.visualSymptoms,
      feedback?.rectalTemperature,
      _mapToDateRepository(feedback?.rectalTemperatureTime),
      feedback?.treatmentNote,
      feedback?.generalNote,
      feedback?.milkDropped,
      feedback?.putToSort,
      feedback?.useful,
      feedback?.diagnosis,
    );
  }

  String _mapToDateRepository(DateTime date) {
    if (date == null) {
      return null;
    }
    final f = DateFormat('yyyy-MM-ddTHH:mm');
    return f.format(date);
  }

  String _mapToDateUI(DateTime date) {
    if (date == null) {
      return null;
    }
    final f = DateFormat('dd/MMM/yyyy');
    return f.format(date);
  }
}
