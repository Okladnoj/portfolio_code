import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/components/formers/screen_former.dart';
import 'package:cattle_scan/components/text_field/text_form.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/alerts/widgets/title.dart';
import 'package:flutter/material.dart';

import 'models/sing_up_model_ui.dart';
import 'sing_up_interactor.dart';

class SingUpPage extends StatefulWidget {
  static const id = 'SingUpPage';

  const SingUpPage({
    Key key,
  }) : super(key: key);

  @override
  _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _nameFarm = TextEditingController();
  final TextEditingController _nameFarmer = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  SingUpInteractor _singUpInteractor;
  SingUpModelUI _singUpModelUI;

  @override
  void initState() {
    _singUpInteractor = SingUpInteractor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFormer(
      titleActions: _buildTitleAlerts(),
      bottomButton: _buildButtonSaveCow(),
      children: [
        _buildContent(),
        const SizedBox(height: 600),
      ],
    );
  }

  Widget _buildTitleAlerts() {
    return const TitleAlerts(nameTitle: 'Create Farm');
  }

  Widget _buildContent() {
    return StreamBuilder<SingUpModelUI>(
      stream: _singUpInteractor?.observer,
      builder: (context, snapshot) {
        _singUpModelUI = snapshot?.data ?? _singUpModelUI;
        return Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Column(
              children: [
                _buildTitleOfControlsPart('Add farm name'),
                TextFormDesign(
                  controller: ValueNotifier(_nameFarm),
                  validator: (value) {
                    if (value.isEmpty) return 'Empty';
                    return null;
                  },
                  style: ValueNotifier(styleField),
                  keyboardType: TextInputType.text,
                  hintText: 'Enter farm Name',
                  onChanged: (animalId) {
                    //
                  },
                ),
                _buildTitleOfControlsPart('Add your name'),
                TextFormDesign(
                  controller: ValueNotifier(_nameFarmer),
                  validator: (value) {
                    if (value.isEmpty) return 'Empty';
                    return null;
                  },
                  style: ValueNotifier(styleField),
                  keyboardType: TextInputType.text,
                  hintText: 'Enter your Name',
                  onChanged: (animalId) {
                    //
                  },
                ),
                _buildTitleOfControlsPart('Add email'),
                TextFormDesign(
                  controller: ValueNotifier(_email),
                  validator: (value) {
                    if (value.isEmpty) return 'Empty';
                    final isCorrect =
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                    if (!isCorrect) {
                      return "Email is wrong";
                    }
                    return null;
                  },
                  style: ValueNotifier(styleField),
                  keyboardType: TextInputType.text,
                  hintText: 'Enter Email',
                  onChanged: (animalId) {
                    //
                  },
                ),
                _buildTitleOfControlsPart('Add Password'),
                TextFormDesign(
                  controller: ValueNotifier(_password),
                  style: ValueNotifier(styleField),
                  keyboardType: TextInputType.text,
                  hintText: 'Enter  Password',
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
                    if (value != _password.text) return "Not Match";
                    return null;
                  },
                  onChanged: (animalId) {
                    //
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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

  Widget _buildButtonSaveCow() {
    return StreamBuilder<SingUpModelUI>(
        stream: _singUpInteractor?.observer,
        builder: (context, snapshot) {
          _singUpModelUI = snapshot?.data ?? _singUpModelUI;
          final isValidate = _singUpModelUI?.isValidate ?? false;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: InkCustomButton(
              height: 50,
              onTap: isValidate
                  ? () {
                      final isValidate = _form.currentState.validate();
                      if (isValidate) {
                        _singUpInteractor.createFarm();
                      }
                    }
                  : null,
              child: Container(
                alignment: const Alignment(0, 0),
                decoration: DesignStile.buttonDecoration(
                  blurRadius: 10,
                  borderRadius: 40,
                  offset: const Offset(0, 2),
                  colorBorder: isValidate ? DesignStile.white : DesignStile.disable,
                  colorBoxShadow: isValidate ? DesignStile.red : DesignStile.black,
                  color: isValidate ? DesignStile.primary : DesignStile.grey,
                ),
                child: Text(
                  'Create Farm',
                  style: DesignStile.textStyleCustom(
                    fontSize: 24,
                    color: isValidate ? DesignStile.white : DesignStile.disable,
                  ),
                ),
              ),
            ),
          );
        });
  }

  static TextStyle styleField = DesignStile.textStyleCustom(
    fontWeight: FontWeight.w300,
    fontSize: 16,
    color: DesignStile.dark,
  );
}
