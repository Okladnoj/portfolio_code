import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/components/text_field/text_form.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:flutter/material.dart';

import '../app_settings_interactor.dart';
import '../models/app_settings_model_ui.dart';

class PopAppPassword extends StatefulWidget {
  final AppSettingModelUI appSettingModelUI;
  final AppSettingInteractor appSettingInteractor;

  const PopAppPassword({
    Key key,
    this.appSettingModelUI,
    this.appSettingInteractor,
  }) : super(key: key);

  @override
  _PopAppPasswordState createState() => _PopAppPasswordState();
}

class _PopAppPasswordState extends State<PopAppPassword> {
  AppSettingModelUI _appSettingModelUI;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void initState() {
    _appSettingModelUI = widget.appSettingModelUI;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppSettingModelUI>(
      stream: widget?.appSettingInteractor?.observer,
      builder: (context, snapshot) {
        _appSettingModelUI = snapshot?.data ?? _appSettingModelUI;
        return _buildSettingsPart(
          475,
          'Change Password',
          _buildPasswordControl(),
        );
      },
    );
  }

  Widget _buildSettingsPart(
    double height,
    String string,
    List<Widget> settingsControl,
  ) {
    final heightFull = MediaQuery.of(context).size.height;
    final Widget child = Scaffold(
      backgroundColor: Colors.transparent,
      body: Hero(
        tag: string,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          margin:
              EdgeInsets.only(left: 10, right: 10, top: (heightFull - height) / 2, bottom: (heightFull - height) / 2),
          decoration: DesignStile.buttonDecoration(
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                string,
                style: DesignStile.textStyleCustom(
                  color: DesignStile.dark,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              Form(key: _form, child: Column(children: settingsControl)),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  _buildButtonSaveSettings(false, 'Close'),
                  _buildButtonSaveSettings(true, 'Save'),
                ]),
              ),
              SizedBox(height: height - 200),
            ],
          ),
        ),
      ),
    );

    return Hero(
      tag: string,
      child: Container(
        height: 50,
        width: double.maxFinite,
        margin: const EdgeInsets.only(left: 15, right: 15, top: 30),
        decoration: DesignStile.buttonDecoration(
          blurRadius: 10,
          offset: const Offset(0, 1),
        ),
        child: InkCustomButton(
          onTap: () {
            AppNavigator.dialog(child);
          },
          child: Center(
            child: Text(
              string,
              style: DesignStile.textStyleCustom(
                color: DesignStile.dark,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPasswordControl() {
    return [
      _buildTitleOfControlsPart('Current Password'),
      TextFormDesign(
        controller: ValueNotifier(_password),
        style: ValueNotifier(styleField),
        keyboardType: TextInputType.text,
        hintText: 'Enter Password',
        validator: (value) {
          if (value.isEmpty) return 'Empty';
          return null;
        },
        onChanged: (animalId) {
          //
        },
      ),
      _buildTitleOfControlsPart('New Password'),
      TextFormDesign(
        controller: ValueNotifier(_newPassword),
        style: ValueNotifier(styleField),
        keyboardType: TextInputType.text,
        hintText: 'Enter new Password',
        validator: (value) {
          if (value.isEmpty) return 'Empty';
          return null;
        },
        onChanged: (animalId) {
          //
        },
      ),
      _buildTitleOfControlsPart('Confirm Password'),
      TextFormDesign(
        controller: ValueNotifier(_confirmPassword),
        style: ValueNotifier(styleField),
        keyboardType: TextInputType.text,
        hintText: 'Enter new Password',
        validator: (value) {
          if (value.isEmpty) return 'Empty';
          if (value != _newPassword.text) return "Not Match";
          return null;
        },
        onChanged: (animalId) {
          //
        },
      ),
    ];
  }

  Widget _buildTitleOfControlsPart(String string) {
    return Row(
      children: [
        Text(
          string,
          style: DesignStile.textStyleCustom(
            color: DesignStile.grey,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonSaveSettings(bool isSave, String string) {
    return Expanded(
      child: StreamBuilder<AppSettingModelUI>(
          stream: widget.appSettingInteractor?.observer,
          builder: (context, snapshot) {
            _appSettingModelUI = snapshot?.data ?? _appSettingModelUI;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: InkCustomButton(
                height: 50,
                onTap: () async {
                  if (isSave) {
                    final isValidate = _form.currentState.validate();
                    if (isValidate) {
                      final isSuccess = await widget.appSettingInteractor.savePassword(
                        _appSettingModelUI.email,
                        _newPassword.text,
                        _password.text,
                      );
                      if (!isSuccess) {
                        _password.clear();
                        AppNavigator.showSnackBar('Wrong Password');
                      } else {
                        AppNavigator.pop();
                      }
                    }
                  } else {
                    AppNavigator.pop();
                  }
                },
                child: Container(
                  alignment: const Alignment(0, 0),
                  decoration: DesignStile.buttonDecoration(
                    blurRadius: 10,
                    borderRadius: 10,
                    offset: const Offset(0, 2),
                    colorBoxShadow: isSave ? DesignStile.red : DesignStile.grey,
                    color: isSave ? DesignStile.primary : DesignStile.grey,
                  ),
                  child: Text(
                    string,
                    style: DesignStile.textStyleCustom(
                      fontSize: 24,
                      color: DesignStile.white,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  static TextStyle styleField = DesignStile.textStyleCustom(
    fontWeight: FontWeight.w300,
    fontSize: 16,
    color: DesignStile.dark,
  );
}
