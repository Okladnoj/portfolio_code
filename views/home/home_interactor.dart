import 'dart:async';

import 'package:flutter/services.dart';

import 'data/load_data.dart';
import 'models/home_model.dart';
import 'models/home_model_ui.dart';

class HomeInteractor {
  HomeInteractor() {
    init();
  }

  final StreamController<HomeModelUI> _controller = StreamController.broadcast();
  StreamSink<HomeModelUI> get sink => _controller.sink;
  Stream<HomeModelUI> get observer => _controller.stream;

  HomeModels _alertsModel;
  HomeService _alertsMasterService;

  void init() {
    _alertsMasterService = HomeService();
    _loadInfo();
  }

  Future<void> dispose() async {
    await _controller.close();
  }

  void switchTimePeriod(CurrentPeriod currentPeriod) {
    _alertsModel = _alertsModel.copy(currentPeriod: currentPeriod);
    _updateUI();
  }

  Future<void> _loadInfo() async {
    _alertsModel = await _alertsMasterService.getFarmInfo();
    _updateUI();
  }

  Future<void> updateInfo() async {
    final alertsModel = await _alertsMasterService?.getFarmInfo();
    _alertsModel = alertsModel.copy(currentPeriod: _alertsModel?.currentPeriod);
    _updateUI();
  }

  void _updateUI() {
    sink.add(_mapToUI());
  }

  HomeModelUI _mapToUI() {
    HomeModel dada;
    if (_alertsModel?.currentPeriod == CurrentPeriod.week) {
      dada = _alertsModel.homeModelWeek;
    } else {
      dada = _alertsModel.homeModel24h;
    }

    return HomeModelUI(
      currentPeriod: _alertsModel?.currentPeriod,
      farmName: dada.farmName,
      activeCows: dada.activeCows,
      in24Seen: dada.in24Seen,
      highTemp: MonitorModelUI(name: 'Critical Temp', value: dada.highTemp),
      sustainTemp: MonitorModelUI(name: 'Sustain Temp', value: dada.sustainTemp),
      lowTemp: MonitorModelUI(name: 'Low Temp', value: dada.lowTemp),
      waterIntake: MonitorModelUI(name: 'Water-Intake', value: dada.waterIntake),
      calving: MonitorModelUI(name: 'Calving Prediction', value: dada.calving),
      groups: _mapToGroups(dada.lactationGroups),
      lactationStages: _mapToLactationStages(dada.lactationStagesNames, dada.lactationStages),
    );
  }

  List<GroupsModelUI> _mapToGroups(LactationGroupsModel lactationGroups) {
    return [
      GroupsModelUI(name: 'Group 1', value: lactationGroups.g1),
      GroupsModelUI(name: 'Group 2', value: lactationGroups.g2),
      GroupsModelUI(name: 'Group 3', value: lactationGroups.g3),
      GroupsModelUI(name: 'Group 4', value: lactationGroups.g4),
      GroupsModelUI(name: 'Group 5', value: lactationGroups.g5),
      GroupsModelUI(name: 'Undefined', value: lactationGroups.undefined),
    ];
  }

  List<LactationModelUI> _mapToLactationStages(LactationStagesNamesModel n, LactationStagesModel s) {
    return [
      LactationModelUI(name: n?.noBred, value: s?.noBred),
      LactationModelUI(name: n?.preg, value: s?.preg),
      LactationModelUI(name: n?.bred, value: s?.bred),
      LactationModelUI(name: n?.okOpen, value: s?.okOpen),
      LactationModelUI(name: n?.dry, value: s?.dry),
      LactationModelUI(name: n?.fresh, value: s?.fresh),
    ];
  }
}
