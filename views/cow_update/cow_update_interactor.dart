import 'dart:async';

import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:intl/intl.dart';

import 'domain/cow_update_repository.dart';
import 'models/cow_update_model.dart';
import 'models/cow_update_model_ui.dart';

class CowUpdateInteractor {
  CowUpdateInteractor() {
    _init();
  }

  final StreamController<CowUpdateModelUI> _controller = StreamController.broadcast();
  StreamSink<CowUpdateModelUI> get sink => _controller.sink;
  Stream<CowUpdateModelUI> get observer => _controller.stream;

  CowUpdateModel _cowUpdateModel;
  CowUpdateRepository _cowUpdateRepository;
  final _f = DateFormat('dd/MMM/yyyy');

  void dispose() {
    _controller.close();
  }

  void updateLactationStage(String lactationStage) {
    _cowUpdateModel = _cowUpdateModel.copy(lactationStage: lactationStage);
    _updateUI();
  }

  void updateDateLactationStart(DateTime dateLactationStart) {
    _cowUpdateModel = _cowUpdateModel.copy(dateLactationStart: dateLactationStart);
    _updateUI();
  }

  Future<void> setPreInfo(int animalId, int bolusId, String currentLactation, String lactationStage) async {
    final date = DateTime.now();
    _cowUpdateModel = CowUpdateModel(
      animalId,
      lactationStage,
      date,
    );
    await Future.value();
    _updateUI();
  }

  Future<bool> uploadInfo() async {
    _updateUI();

    final isUpdate = await _cowUpdateRepository.updateInfo(_cowUpdateModel);

    if (isUpdate) {
      AppNavigator.showSnackBar('Cow update', colorText: DesignStile.green);
    } else {
      AppNavigator.showSnackBar('Cow not update');
    }
    return isUpdate;
  }

  void _init() {
    _cowUpdateRepository = CowUpdateRepository();
  }

  void _updateUI() {
    sink.add(_mapToUI());
  }

  CowUpdateModelUI _mapToUI() {
    return CowUpdateModelUI(
      _cowUpdateModel?.animalId,
      _cowUpdateModel?.lactationStage,
      _f.format(_cowUpdateModel?.dateLactationStart),
    );
  }
}
