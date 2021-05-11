import 'dart:async';

import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/alerts/models/alert_model.dart';
import 'package:cattle_scan/views/alerts/models/alert_model_ui.dart';
import 'package:intl/intl.dart';

import 'domain/domain_service.dart';
import 'models/diagnose_model.dart';

class CreateEventsInteractor {
  CreateEventsInteractor() {
    init();
  }

  final StreamController<DiagnoseModels> _controller = StreamController.broadcast();
  StreamSink<DiagnoseModels> get sink => _controller.sink;
  Stream<DiagnoseModels> get observerDiagnoses => _controller.stream;

  final StreamController<EventModelUI> _controllerEventOfAlert = StreamController.broadcast();
  StreamSink<EventModelUI> get sinkEventOfAlert => _controllerEventOfAlert.sink;
  Stream<EventModelUI> get observerEventOfAlert => _controllerEventOfAlert.stream;

  DomainService _eventService;
  EventModel _eventModel;

  void init() {
    _eventService = DomainService();
    _eventModel = EventModel.nul();
    _initModelUI();
    _upLoadDiagnoseModels();
  }

  Future<void> _initModelUI() async {
    await Future.value();
    _updateEventUI();
  }

  Future<void> _upLoadDiagnoseModels() async {
    final diagnoseModels = await _eventService.loadDiagnoses();
    sink.add(diagnoseModels);
  }

  Future<bool> upLoadEvent() async {
    final isCompile = await _eventService.upLoadEvent(_eventModel);

    if (isCompile) {
      AppNavigator.showSnackBar(
        'Event save to server',
        backgroundColor: DesignStile.grey,
        colorText: DesignStile.white,
        isUpperCase: false,
      );
    } else {
      AppNavigator.showSnackBar(
        'Error, Event not save',
        backgroundColor: DesignStile.grey,
        colorText: DesignStile.white,
        isUpperCase: false,
      );
    }
    return isCompile;
  }

  void setAnimalId(int animalId) {
    _eventModel = _eventModel.copy(objectId: animalId);
  }

  void setAlertId(int alertId) {
    _eventModel = _eventModel.copy(id: alertId);
  }

  void dellData() {
    _eventModel.date = null;
    _updateEventUI();
  }

  void setData(DateTime date) {
    _eventModel = _eventModel.copy(date: date);
    _updateEventUI();
  }

  void setEventType(String eventType, [bool isUpdate = true]) {
    _eventModel = _eventModel.copy(eventType: eventType);
    if (isUpdate) {
      _updateEventUI();
    }
  }

  void dellEventType([bool isUpdate = true]) {
    _eventModel.eventType = null;
    if (isUpdate) {
      _updateEventUI();
    }
  }

  void setRemark(String remark, [bool isUpdate = true]) {
    _eventModel = _eventModel.copy(remark: remark);
    if (isUpdate) {
      _updateEventUI();
    }
  }

  void dellRemark([bool isUpdate = true]) {
    _eventModel.remark = null;
    if (isUpdate) {
      _updateEventUI();
    }
  }

  void setProtocol(String protocols, [bool isUpdate = true]) {
    _eventModel = _eventModel.copy(protocols: protocols);
    if (isUpdate) {
      _updateEventUI();
    }
  }

  void dellProtocol([bool isUpdate = true]) {
    _eventModel.protocols = null;
    if (isUpdate) {
      _updateEventUI();
    }
  }

  Future<void> dispose() async {
    await _controller.close();
    await _controllerEventOfAlert.close();
  }

  EventModelUI _mapToUI() {
    return EventModelUI(
      _eventModel.id,
      _eventModel.objectId,
      _eventModel.farmId,
      _eventModel.eventType,
      _mapToDateUI(_eventModel.date),
      _eventModel.description,
      _eventModel.name,
      _eventModel.remark,
      _eventModel.result,
      _eventModel.daysInMilk,
      _eventModel.protocols,
      _eventModel.alerts,
    );
  }

  String _mapToDateUI(DateTime date) {
    if (date == null) {
      return null;
    }
    final f = DateFormat('dd/MMM/yyyy');
    return f.format(date);
  }

  void _updateEventUI() {
    sinkEventOfAlert.add(_mapToUI());
  }
}
