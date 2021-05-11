import 'dart:async';

import 'domain/about_app_repository.dart';
import 'models/about_app_model.dart';
import 'models/about_app_model_ui.dart';

class AboutAppInteractor {
  AboutAppInteractor() {
    _init();
  }

  final StreamController<AboutAppModelUI> _controller = StreamController.broadcast();
  StreamSink<AboutAppModelUI> get sink => _controller.sink;
  Stream<AboutAppModelUI> get observer => _controller.stream;

  AboutAppModel _aboutAppModel;
  AboutAppRepository _aboutAppRepository;

  void dispose() {
    _controller.close();
  }

  void _init() {
    _aboutAppRepository = AboutAppRepository();

    _loadData();
  }

  Future<void> _loadData() async {
    _aboutAppModel = await _aboutAppRepository.loadData();
    _updateUI();
  }

  void _updateUI() {
    sink.add(_mapToUI());
  }

  AboutAppModelUI _mapToUI() {
    return AboutAppModelUI(
      appInfoModel(_aboutAppModel?.appInfoModel),
      deviceInfoModel(_aboutAppModel?.deviceInfoModel),
      ourContactsModel(_aboutAppModel?.ourContactsModel),
    );
  }

  AppInfoModelUI appInfoModel(AppInfoModel appInfoModel) {
    return AppInfoModelUI(
      appInfoModel?.title,
      appInfoModel?.version,
    );
  }

  DeviceInfoModelUI deviceInfoModel(DeviceInfoModel deviceInfoModel) {
    return DeviceInfoModelUI(
      deviceInfoModel?.title,
      deviceInfoModel?.version,
      deviceInfoModel?.model,
      deviceInfoModel?.brand,
    );
  }

  OurContactsModelUI ourContactsModel(OurContactsModel ourContactsModel) {
    return OurContactsModelUI(
      ourContactsModel?.title,
      ourContactsModel?.address,
      ourContactsModel?.phone,
      ourContactsModel?.email,
    );
  }
}
