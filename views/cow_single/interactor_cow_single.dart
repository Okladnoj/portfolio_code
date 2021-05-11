import 'dart:async';

import 'domain/load.data.dart';
import 'models/cow_single_ui.dart';

class CowSingleInteractor {
  static final Map<int, CowSingleModelUI> _cowSingleModelUI = {};

  final StreamController<Map<int, CowSingleModelUI>> _controller = StreamController.broadcast();
  StreamSink<Map<int, CowSingleModelUI>> get sink => _controller.sink;
  Stream<Map<int, CowSingleModelUI>> get observer => _controller.stream;

  Future<void> dispose() async {
    await _controller.close();
  }

  Map<int, CowSingleModelUI> get mapOfCowSingleModelUI => _cowSingleModelUI;

  Future<void> _updateUI(CowSingleModelUI cowSingleModelUI) async {
    setCowSingleModelUI = cowSingleModelUI;
    sink?.add(_cowSingleModelUI);
  }

  Future<void> updateUI() async {
    await Future.delayed(const Duration());
    sink?.add(_cowSingleModelUI);
  }

  Future<void> updateDataOfDayAndWeek(int animalId, int bolusId) async {
    CowSingleModelUI cowSingleModelUI;
    cowSingleModelUI = await loadDataOfDayAndWeek(animalId, bolusId);
    await _updateUI(cowSingleModelUI);
  }

  Future<void> updateDataOfDay(int animalId, int bolusId) async {
    final cowSingleModelUI = await loadDataOfDay(animalId, bolusId);
    await _updateUI(cowSingleModelUI);
  }

  Future<void> updateAlerts(int animalId) async {
    final cowSingleModelUI = getCowSingleModelUI(animalId);
    final cowSingleModeUpdatedUI = await loadDataOfAlerts(cowSingleModelUI);
    await _updateUI(cowSingleModeUpdatedUI);
  }

  // ignore: avoid_setters_without_getters
  set setCowSingleModelUI(CowSingleModelUI cowSingleModelUI) {
    if (cowSingleModelUI != null) {
      _cowSingleModelUI[cowSingleModelUI.animalId] = cowSingleModelUI;
    }
  }

  CowSingleModelUI getCowSingleModelUI(int animalId) {
    return _cowSingleModelUI[animalId];
  }
}
