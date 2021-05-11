import 'package:cattle_scan/api/api.dart';
import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/components/formers/screen_former.dart';
import 'package:cattle_scan/pre_start_app/pre_start_app.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/alerts/widgets/title.dart';
import 'package:flutter/material.dart';

class HostChangePage extends StatefulWidget {
  static const id = 'HostChangePage';
  const HostChangePage({Key key}) : super(key: key);
  @override
  _HostChangePageState createState() => _HostChangePageState();
}

class _HostChangePageState extends State<HostChangePage> {
  TextEditingController controller =
      TextEditingController(text: CallApi.kBackendAddressApi);
  @override
  Widget build(BuildContext context) {
    return ScreenFormer(
      titleActions: _buildTitleAlerts(),
      children: [
        _buildCurrentHost(),
        _buildInputHost(),
        _buildButtons(),
      ],
    );
  }

  Widget _buildTitleAlerts() {
    return const TitleAlerts(nameTitle: 'Current Host');
  }

  Widget _buildCurrentHost() {
    return Container(
      margin: const EdgeInsets.all(10),
      alignment: const Alignment(0, 0),
      height: 50,
      decoration: DesignStile.buttonDecoration(offset: const Offset(0, 1)),
      child: Text(
        CallApi.kBackendAddressApi,
        style: DesignStile.textStyleCustom(fontSize: 18),
      ),
    );
  }

  Widget _buildInputHost() {
    return Container(
      margin: const EdgeInsets.all(10),
      alignment: const Alignment(0, 0),
      height: 100,
      decoration: DesignStile.buttonDecoration(offset: const Offset(0, 1)),
      child: TextFormField(
        controller: controller,
        maxLength: 200,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        onChanged: (value) {
          controller.text;
        },
      ),
    );
  }

  Widget _buildInputToken() {
    return Container(
      margin: const EdgeInsets.all(10),
      alignment: const Alignment(0, 0),
      height: 100,
      decoration: DesignStile.buttonDecoration(offset: const Offset(0, 1)),
      child: TextFormField(
        controller: TextEditingController(text: CallApi.getToken),
        maxLength: 200,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        onChanged: (value) {
          controller.text;
        },
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        _buildButtonCustom(),
        const SizedBox(height: 25),
        _buildButtonStage(),
        const SizedBox(height: 5),
        _buildButtonProduction(),
        const SizedBox(height: 50),
        _buildInputToken(),
      ],
    );
  }

  Widget _buildButtonCustom() {
    return InkCustomButton(
      height: 50,
      onTap: () async {
        CallApi.updateHost(controller.text);
        await _saveUrlToStorage(controller.text);
        AppNavigator.pop();
        AppNavigator.pop();
        await CallApi.userLogout();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        alignment: const Alignment(0, 0),
        decoration: DesignStile.buttonDecoration(
          offset: const Offset(0, 1),
          color: DesignStile.primary,
        ),
        child: Text(
          'Go to custom',
          style: DesignStile.textStyleCustom(
              fontSize: 18, color: DesignStile.white),
        ),
      ),
    );
  }

  Widget _buildButtonStage() {
    return InkCustomButton(
      height: 50,
      onTap: () async {
        _updateUrlOnApi(stage);
        await _saveUrlToStorage(stage);
        AppNavigator.pop();
        AppNavigator.pop();
        await CallApi.userLogout();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        alignment: const Alignment(0, 0),
        decoration: DesignStile.buttonDecoration(
          offset: const Offset(0, 1),
          color: DesignStile.primary,
        ),
        child: Text(
          'Go to stage',
          style: DesignStile.textStyleCustom(
              fontSize: 18, color: DesignStile.white),
        ),
      ),
    );
  }

  Widget _buildButtonProduction() {
    return InkCustomButton(
      height: 50,
      onTap: () async {
        _updateUrlOnApi(production);
        await _saveUrlToStorage(production);
        AppNavigator.pop();
        AppNavigator.pop();
        await CallApi.userLogout();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        alignment: const Alignment(0, 0),
        decoration: DesignStile.buttonDecoration(
          offset: const Offset(0, 1),
          color: DesignStile.primary,
        ),
        child: Text(
          'Go to production',
          style: DesignStile.textStyleCustom(
              fontSize: 18, color: DesignStile.white),
        ),
      ),
    );
  }

  void _updateUrlOnApi(String url) {
    CallApi.updateHost(url);
  }

  Future<bool> _saveUrlToStorage(String url) {
    return PreStartApp.localStorage.setString(CallApi.keyUrl, url);
  }

  static const stage = 'https://stg.cattlescan.ca/mob/v2/';
  static const production = 'https://api.cattlescan.ca/mob/v2/';
}
