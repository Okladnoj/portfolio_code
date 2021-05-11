import 'package:cattle_scan/settings/constants.dart';
import 'package:flutter/material.dart';

import 'models/user_model.dart';

typedef CallBackBool = Function(bool value);

class SingInButton extends StatefulWidget {
  @override
  // ignore: overridden_fields
  final ValueKey<bool> key;
  final GlobalKey<FormState> formKey;
  final UserModel userModel;
  final CallBackBool callBackBoll;

  const SingInButton({
    this.key,
    this.formKey,
    this.userModel,
    this.callBackBoll,
  }) : super(key: key);
  @override
  _SingInButtonState createState() => _SingInButtonState();
}

class _SingInButtonState extends State<SingInButton> {
  GlobalKey<FormState> _formKey;
  bool _isSinClicked;

  @override
  void initState() {
    _formKey = widget.formKey;
    _isSinClicked = widget.key.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isSinClicked
        ? _buildProgressIndicatorOnButton() //
        : _buildButtonSingIn(context);
  }

  Widget _buildProgressIndicatorOnButton() {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
    );
  }

  Widget _buildButtonSingIn(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: DesignStile.primary,
      ),
      onPressed: () async {
        final formState = _formKey.currentState;
        if (formState.validate()) {
          formState.save();

          setState(() {
            _isSinClicked = true;
          });
        } else {
          _isSinClicked = false;
        }
        widget.callBackBoll(_isSinClicked);
      },
      child: const Text('Sign in'),
    );
  }
}
