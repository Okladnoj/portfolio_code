import 'dart:async';

import 'domain/sing_in_service.dart';
import 'models/user_model.dart';

class SingInInteractor {
  SingInInteractor() {
    init();
  }

  final StreamController<bool> _controller = StreamController.broadcast();
  StreamSink<bool> get sink => _controller.sink;
  Stream<bool> get observer => _controller.stream;

  SingInService _singInService;

  void init() {
    _singInService = SingInService()..init();
  }

  Future<void> singIn(UserModel userModel) async {
    userModel
      ..email = userModel?.email?.replaceAll(' ', '')
      ..password = userModel?.password?.replaceAll(' ', '');
    _singInService.singIn(userModel);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
