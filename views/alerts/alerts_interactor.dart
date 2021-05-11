import 'dart:async';

import 'package:cattle_scan/components/logic/text_format.dart';
import 'package:cattle_scan/views/alerts/models/alert_model_ui.dart';
import 'package:cattle_scan/views/cow_single/domain/functions/load_alerts_data.dart';
import 'package:intl/intl.dart';

import 'domain/filter_model.dart';
import 'domain/load_data.dart';
import 'models/alert_model.dart';

class AlertsInteractor {
  AlertsInteractor() {
    init();
  }

  final StreamController<AlertsModelUI> _controller = StreamController.broadcast();
  StreamSink<AlertsModelUI> get sink => _controller.sink;
  Stream<AlertsModelUI> get observer => _controller.stream;

  AlertsModel _alertsModel;
  AlertsService _alertsService;
  FilterToAlerts _filterToAlerts;

  void init() {
    _alertsService = AlertsService();
  }

  void dispose() {
    _controller.close();
  }

  Future<void> loadDataFilter(FilterToAlerts filterToAlerts) async {
    _filterToAlerts = filterToAlerts;
    _alertsModel = await _alertsService?.loadAlertsModel(_filterToAlerts);
    _updateUI();
  }

  Future<void> loadAlertsDataByBolusId(int bolusId) async {
    _filterToAlerts = FilterToAlerts(listKeys: [
      '$bolusId',
      '0',
    ]);
    _alertsModel = await getAlertsData(bolusId);
    _updateUI();
  }

  Future<bool> updateReadStatusForAlert(int alertId) async {
    final result = await _alertsService?.updateReadStatusForAlert(alertId);
    _alertsModel = await _alertsService?.loadAlertsModel(_filterToAlerts);
    _updateUI();
    return result;
  }

  Future<void> simpleUpdate() async {
    _alertsModel = await _alertsService?.loadAlertsModel(_filterToAlerts);
    _updateUI();
  }

  void _updateUI() {
    sink.add(_groupAlertsModel());
  }

  AlertsModelUI _mapToUI() {
    return AlertsModelUI(
      _alertsModel?.status,
      _mapToListAlertModelUI(_alertsModel?.listAlerts),
    );
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

  String _mapToDateUI(DateTime date) {
    if (date == null) {
      return null;
    }
    final f = DateFormat('dd/MMM/yyyy');
    return f.format(date);
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

  AlertsModelUI _groupAlertsModel() {
    final a = _mapToUI();
    final isCih = _filterToAlerts.listKeys.contains('CIH');
    if (isCih) {
      final listGroupAlerts = <AlertModelUI>[];
      final listBolusId = <int>[];
      for (final alert in a.listAlerts) {
        final listAlerts = <AlertModelUI>[];
        final bolusId = alert.bolusId;

        if (!listBolusId.contains(bolusId)) {
          listBolusId.add(bolusId);
          for (final alert in a.listAlerts) {
            if (alert.bolusId == bolusId) {
              listAlerts.add(alert);
            }
          }
          if (listAlerts.isNotEmpty) {
            alert.listAlertModelUI.addAll(listAlerts);
            listGroupAlerts.add(alert);
          }
        }
      }
      a.listAlerts.clear();
      a.listAlerts.addAll(listGroupAlerts);
      return a;
    } else {
      return a;
    }
  }

  String _mapToDateRepository(DateTime date) {
    if (date == null) {
      return null;
    }
    final f = DateFormat('yyyy-MM-ddTHH:mm');
    return f.format(date);
  }
}
