import 'dart:async';

import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/settings/constants.dart';

import 'domain/sing_up_repository.dart';
import 'models/sing_up_model.dart';
import 'models/sing_up_model_ui.dart';

class SingUpInteractor {
  SingUpInteractor() {
    _init();
  }

  final StreamController<SingUpModelUI> _controller = StreamController.broadcast();
  StreamSink<SingUpModelUI> get sink => _controller.sink;
  Stream<SingUpModelUI> get observer => _controller.stream;

  SingUpModel _singUpModel;
  SingUpRepository _singUpRepository;

  void dispose() {
    _controller.close();
  }

  void _init() {
    _singUpRepository = SingUpRepository();
    _singUpModel = SingUpModel.empty();
  }

  Future createFarm() async {
    final isSave = await _singUpRepository?.createFarm(_singUpModel);

    if (isSave) {
      AppNavigator.showSnackBar('Save Notification', colorText: DesignStile.green);
    } else {
      AppNavigator.showSnackBar('Not save Notification');
    }
    _updateUI();
  }

  void _updateUI() {
    sink.add(_mapToUI());
  }

  SingUpModelUI _mapToUI() {
    return SingUpModelUI(
      _singUpModel?.nameFarm,
      _singUpModel?.nameFarmer,
      _singUpModel?.email,
      _singUpModel?.password,
    );
  }
}
