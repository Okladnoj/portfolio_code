import 'dart:async';

import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:intl/intl.dart';

import 'domain/cow_add_repository.dart';
import 'models/cow_add_model.dart';
import 'models/cow_add_model_ui.dart';

class CowAddInteractor {
  CowAddInteractor() {
    _init();
  }

  final StreamController<CowAddModelUI> _controller = StreamController.broadcast();
  StreamSink<CowAddModelUI> get sink => _controller.sink;
  Stream<CowAddModelUI> get observer => _controller.stream;

  CowAddModel _cowAddModel;
  CowAddRepository _cowAddRepository;

  void dispose() {
    _controller.close();
  }

  void _init() {
    _cowAddRepository = CowAddRepository();
    _cowAddModel = CowAddModel.empty();
  }

  Future<void> onChangeBolusId(String bolusId) async {
    _cowAddModel = _cowAddModel.copy(bolusId: bolusId);
    _updateUI();

    await _checkConnectBolusId();
  }

  Future<void> _checkConnectBolusId() async {
    final isConnect = await _cowAddRepository.connectBolus(_cowAddModel);

    _cowAddModel = _cowAddModel.copy(checkCow: isConnect);
    _updateUI();
  }

  Future<void> onChangeAnimalId(String animalId) async {
    _cowAddModel = _cowAddModel.copy(animalId: animalId);
    _updateUI();
    if (_cowAddModel?.bolusId?.isNotEmpty ?? false) {
      await _checkConnectBolusId();
    }
  }

  Future<void> onChangeDateOfBirth(DateTime dateOfBirth) async {
    _cowAddModel = _cowAddModel.copy(dateOfBirth: dateOfBirth);
    _updateUI();
  }

  Future<void> onChangeLactationNumber(int lactationNumber) async {
    _cowAddModel = _cowAddModel.copy(lactationNumber: lactationNumber);
    _updateUI();
  }

  Future<void> onChangeLactationStage(String lactationStage) async {
    _cowAddModel = _cowAddModel.copy(lactationStage: lactationStage);
    _updateUI();
  }

  Future<void> onChangeDateLactationStart(DateTime dateLactationStart) async {
    _cowAddModel = _cowAddModel.copy(dateLactationStart: dateLactationStart);
    _updateUI();
  }

  Future<void> onSaveCow() async {
    _cowAddRepository.createCow(_cowAddModel).then((value) {
      if (value) {
        AppNavigator.showSnackBar('Cow created', colorText: DesignStile.green);
      } else {
        AppNavigator.showSnackBar('Cow not created');
      }
    });
    AppNavigator.pop();
  }

  void _updateUI() {
    sink.add(_mapToUI());
  }

  CowAddModelUI _mapToUI() {
    return CowAddModelUI(
      _cowAddModel?.bolusId,
      _cowAddModel?.animalId,
      _cowAddModel?.checkCow,
      _formatDataToString(_cowAddModel?.dateOfBirth),
      _cowAddModel?.lactationNumber?.toString(),
      _cowAddModel?.lactationStage,
      _formatDataToString(_cowAddModel?.dateLactationStart),
    );
  }

  String _formatDataToString(DateTime dateTime) {
    try {
      return _f.format(dateTime);
    } catch (e) {
      return '';
    }
  }

  final _f = DateFormat('dd/MMM/yyyy');
}
