import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/components/formers/screen_former.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/alerts/widgets/title.dart';
import 'package:flutter/material.dart';

import 'about_app_interactor.dart';
import 'models/about_app_model_ui.dart';

class AboutAppPage extends StatefulWidget {
  static const String id = 'AboutAppPage';

  const AboutAppPage({Key key}) : super(key: key);
  @override
  _AboutAppPageState createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  AboutAppInteractor _aboutAppInteractor;
  AboutAppModelUI _aboutAppModelUI;

  DateTime _tapTime = DateTime.now();
  int _tapNum = 0;

  @override
  void initState() {
    super.initState();
    _aboutAppInteractor = AboutAppInteractor();
  }

  @override
  void dispose() {
    _aboutAppInteractor?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFormer(
      titleActions: _buildTitle(),
      children: [
        _buildContent(),
      ],
    );
  }

  Widget _buildTitle() {
    return const TitleAlerts(nameTitle: 'About the App');
  }

  Widget _buildContent() {
    return StreamBuilder<AboutAppModelUI>(
        stream: _aboutAppInteractor.observer,
        builder: (context, snapshot) {
          _aboutAppModelUI = snapshot?.data ?? _aboutAppModelUI;
          return Column(
            children: [
              GestureDetector(
                onTap: _navigateOnChangeHostIfSeriesTap,
                child: Container(
                  color: const Color(0x00000000),
                  child: _buildTitleSection(_aboutAppModelUI?.appInfoModel?.title ?? ''),
                ),
              ),
              _buildBodySection(_aboutAppModelUI?.appInfoModel?.version ?? ''),

              ///
              _buildTitleSection(_aboutAppModelUI?.deviceInfoModel?.title ?? ''),
              _buildBodySection(_aboutAppModelUI?.deviceInfoModel?.version ?? ''),
              _buildBodySection(_aboutAppModelUI?.deviceInfoModel?.model ?? ''),
              _buildBodySection(_aboutAppModelUI?.deviceInfoModel?.brand ?? ''),

              ///
              _buildTitleSection(_aboutAppModelUI?.ourContactsModel?.title ?? ''),
              _buildBodySection(_aboutAppModelUI?.ourContactsModel?.address ?? ''),
              _buildBodySection(_aboutAppModelUI?.ourContactsModel?.phone ?? ''),
              _buildBodySection(_aboutAppModelUI?.ourContactsModel?.email ?? ''),
            ],
          );
        });
  }

  void _navigateOnChangeHostIfSeriesTap() {
    final tapTime = DateTime.now();
    final difference = tapTime.difference(_tapTime);
    if (difference.inMilliseconds < 500) {
      _tapNum++;
    } else {
      _tapNum = 0;
    }
    if (_tapNum > 6) {
      AppNavigator.navigateToHostChangePage();
      _tapNum = 0;
    }
    _tapTime = tapTime;
  }

  Widget _buildTitleSection(String string) {
    return Container(
      alignment: const Alignment(0, 1),
      margin: const EdgeInsets.only(left: 15, right: 15, top: 45),
      child: Text(
        string,
        style: DesignStile.textStyleCustom(
          fontSize: 24,
          color: DesignStile.dark,
        ),
      ),
    );
  }

  Widget _buildBodySection(String string) {
    return Container(
      alignment: const Alignment(-1, 1),
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Text(
        string,
        style: DesignStile.textStyleCustom(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: DesignStile.dark,
        ),
      ),
    );
  }
}
