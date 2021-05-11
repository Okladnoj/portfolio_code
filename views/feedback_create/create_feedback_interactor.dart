import 'dart:async';

import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/alerts/models/alert_model.dart';
import 'package:cattle_scan/views/alerts/models/alert_model_ui.dart';
import 'package:intl/intl.dart';

import 'domain/domain_service.dart';

class AlertsOfFeedbackInteractor {
  AlertsOfFeedbackInteractor() {
    init();
  }

  final StreamController<bool> _controller = StreamController.broadcast();
  StreamSink<bool> get sink => _controller.sink;
  Stream<bool> get observer => _controller.stream;

  final StreamController<FeedbackModelUI> _controllerFeedbackOfAlert = StreamController.broadcast();
  StreamSink<FeedbackModelUI> get sinkFeedbackOfAlert => _controllerFeedbackOfAlert.sink;
  Stream<FeedbackModelUI> get observerFeedbackOfAlert => _controllerFeedbackOfAlert.stream;

  DomainService _alertsMasterService;
  FeedbackModel _feedBackModel;

  void init() {
    _alertsMasterService = DomainService();
    _feedBackModel = FeedbackModel.nul();
  }

  Future<bool> upLoadFeedback() async {
    final isCompile = await _alertsMasterService.upLoadFeedback(_feedBackModel);
    sink.add(isCompile);
    if (isCompile) {
      AppNavigator.showSnackBar(
        'Feedback save to server',
        backgroundColor: DesignStile.grey,
        colorText: DesignStile.white,
        isUpperCase: false,
      );
    } else {
      AppNavigator.showSnackBar(
        'Error, feedback not save',
        backgroundColor: DesignStile.grey,
        colorText: DesignStile.white,
        isUpperCase: false,
      );
    }
    return isCompile;
  }

  void setAlertId(int alertId) {
    _feedBackModel = _feedBackModel.copy(id: alertId);
  }

  void simpleUpdate() {
    _updateFeedBackUI();
  }

  void setVisualSymptoms(bool _) {
    _feedBackModel = _feedBackModel.copy(visualSymptoms: _);
    _updateFeedBackUI();
  }

  void setMilkDropped(bool _) {
    _feedBackModel = _feedBackModel.copy(milkDropped: _);
    _updateFeedBackUI();
  }

  void setPutToSort(bool _) {
    _feedBackModel = _feedBackModel.copy(putToSort: _);
    _updateFeedBackUI();
  }

  void setRectalTemperature(double _, [bool isUpdate = true]) {
    _feedBackModel = _feedBackModel.copy(rectalTemperature: _);
    if (isUpdate) {
      _updateFeedBackUI();
    }
  }

  void dellRectalTemperature() {
    _feedBackModel
      ..rectalTemperature = null
      ..rectalTemperatureTime = DateTime.now();
    _updateFeedBackUI();
  }

  void setRectalTemperatureMeasuringTime(DateTime date) {
    _feedBackModel = _feedBackModel.copy(rectalTemperatureTime: date);
    _updateFeedBackUI();
  }

  void setGeneralNote(String generalNote, [bool isUpdate = true]) {
    _feedBackModel = _feedBackModel.copy(generalNote: generalNote);
    if (isUpdate) {
      _updateFeedBackUI();
    }
  }

  void dellGeneralNote([bool isUpdate = true]) {
    _feedBackModel.generalNote = null;
    if (isUpdate) {
      _updateFeedBackUI();
    }
  }

  void setIsImportant(bool _) {
    _feedBackModel = _feedBackModel.copy(useful: _);
  }

  Future<void> dispose() async {
    await _controller.close();
    await _controllerFeedbackOfAlert.close();
  }

  FeedbackModelUI _mapToUI() {
    return FeedbackModelUI(
      _feedBackModel.id,
      _mapToDateUI(_feedBackModel.created),
      _feedBackModel.visualSymptoms,
      _feedBackModel.rectalTemperature,
      _mapToDateUI(_feedBackModel.rectalTemperatureTime),
      _feedBackModel.treatmentNote,
      _feedBackModel.generalNote,
      _feedBackModel.milkDropped,
      _feedBackModel.putToSort,
      _feedBackModel.useful,
      _feedBackModel.diagnosis,
    );
  }

  String _mapToDateUI(DateTime date) {
    if (date == null) {
      return null;
    }
    final f1 = DateFormat.Hm();
    final time = f1.format(date);
    final f2 = DateFormat('dd/MMM/yyyy');
    final data = f2.format(date);
    return '$data $time';
  }

  void _updateFeedBackUI() {
    sinkFeedbackOfAlert.add(_mapToUI());
  }
}
