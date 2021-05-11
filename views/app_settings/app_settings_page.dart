import 'package:cattle_scan/components/formers/screen_former.dart';
import 'package:cattle_scan/components/safe_text/safe_text.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/alerts/widgets/title.dart';
import 'package:flutter/material.dart';

import 'app_settings_interactor.dart';
import 'components/pop_app_email.dart';
import 'components/pop_app_notification.dart';
import 'components/pop_app_password.dart';
import 'models/app_settings_model_ui.dart';

class AppSettingPage extends StatefulWidget {
  static const id = 'AppSettingPage';

  const AppSettingPage({Key key}) : super(key: key);

  @override
  _AppSettingPageState createState() => _AppSettingPageState();
}

class _AppSettingPageState extends State<AppSettingPage> {
  AppSettingInteractor _appSettingInteractor;
  AppSettingModelUI _appSettingModelUI;

  @override
  void initState() {
    _appSettingInteractor = AppSettingInteractor();
    super.initState();
  }

  @override
  void dispose() {
    _appSettingInteractor?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFormer(
      titleActions: _buildTitleAlerts(),
      children: [
        _buildContent(),
      ],
    );
  }

  Widget _buildTitleAlerts() {
    return const TitleAlerts(nameTitle: 'Settings');
  }

  Widget _buildContent() {
    return StreamBuilder<AppSettingModelUI>(
      stream: _appSettingInteractor?.observer,
      builder: (context, snapshot) {
        _appSettingModelUI = snapshot?.data ?? _appSettingModelUI;
        if (_appSettingModelUI == null) {
          return SizedBox(
            height: 200,
            child: SafeText(
              null,
              style: DesignStile.textStyleCustom(fontSize: 80),
            ),
          );
        }

        return Column(
          children: [
            PopAppEmail(
              appSettingInteractor: _appSettingInteractor,
              appSettingModelUI: _appSettingModelUI,
            ),
            PopAppPassword(
              appSettingInteractor: _appSettingInteractor,
              appSettingModelUI: _appSettingModelUI,
            ),
            PopAppNotification(
              appSettingInteractor: _appSettingInteractor,
              appSettingModelUI: _appSettingModelUI,
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 1.5),
          ],
        );
      },
    );
  }
}
