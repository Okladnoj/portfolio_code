import 'dart:async';

import 'domain/demo_alert_repository.dart';
import 'models/demo_alert_model.dart';
import 'models/demo_alert_model_ui.dart';

class DemoAlertInteractor {
  DemoAlertInteractor() {
    _init();
  }

  final StreamController<DemoAlertModelUI> _controller = StreamController.broadcast();
  StreamSink<DemoAlertModelUI> get sink => _controller.sink;
  Stream<DemoAlertModelUI> get observerDiagnoses => _controller.stream;

  CowUpdateRepository _cowUpdateRepository;
  DemoAlertModel _demoAlertModel;

  void _init() {
    _cowUpdateRepository = CowUpdateRepository();
  }

  void _updateUI() {
    sink.add(_mapToUI());
  }

  void dispose() {
    _controller.close();
  }

  Future<void> onSetDemoRequest() async {
    _demoAlertModel = await _cowUpdateRepository.updateInfo();
    _updateUI();
  }

  DemoAlertModelUI _mapToUI() {
    return DemoAlertModelUI(_demoAlertModel?.isSend);
  }
}
