import 'package:cattle_scan/app/app_navigator.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

import '../../settings/constants.dart';
import 'interactor_sign_in.dart';
import 'models/user_model.dart';
import 'sing_in_button.dart';

class SignInPage extends StatefulWidget {
  static const String id = 'SignInPage';

  const SignInPage({Key key}) : super(key: key);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  SingInInteractor _singInInteractor;
  bool _isSinClicked = false;
  bool _isSingIn = false;
  bool _userPasswordVisible = false;

  UserModel _userModel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _singInInteractor = SingInInteractor();
    _userModel = UserModel();
  }

  Future<bool> _onWillPop() async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(false);
  }

  @override
  Future<void> dispose() async {
    await _singInInteractor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: StreamBuilder<bool>(
          stream: _singInInteractor.observer,
          builder: (context, snapshot) {
            _isSingIn = snapshot?.data ?? false;
            _isSinClicked = _isSingIn;
            print(_isSingIn);
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('Sign in'),
              ),
              body: _isSingIn
                  ? _buildProgressIndicatorOnScreen() //
                  : _buildSingInFields(context),
            );
          }),
    );
  }

  Widget _buildSingInFields(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Image.asset('assets/images/logo.png'),
              ),
              const SizedBox(height: 50.0),
              _buildEmailFormField(),
              const SizedBox(height: 15.0),
              _buildPasswordFormField(context),
              const SizedBox(height: 15.0),
              _buildSingInButton(),
              // const Divider(thickness: 1),
              // _buildTitleSingUpButton(),
              // _buildSingUpButton(),
              SizedBox(height: MediaQuery.of(context).size.height / 1.5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingInButton() {
    return SingInButton(
      formKey: _formKey,
      key: ValueKey(_isSinClicked),
      userModel: _userModel,
      callBackBoll: (value) {
        _isSinClicked = value;
        _singInInteractor.singIn(_userModel);
      },
    );
  }

  Widget _buildSingUpButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: DesignStile.green,
      ),
      onPressed: () {
        AppNavigator.navigateToSingUpPage();
      },
      child: const Text('Sign UP'),
    );
  }

  Widget _buildTitleSingUpButton() {
    return Row(
      children: [
        Text(
          'Registration',
          style: DesignStile.textStyleCustom(
            color: DesignStile.grey,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordFormField(BuildContext context) {
    return TextFormField(
      obscureText: !_userPasswordVisible,
      validator: (input) {
        if (input.isEmpty) {
          return 'Enter your password';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        _userModel.password = value;
      },
      decoration: InputDecoration(
        labelText: 'Password',
        icon: const Icon(
          Icons.lock,
          color: Colors.black,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _userPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            // Update the state i.e. toggle the state of passwordVisible variable
            setState(() {
              _userPasswordVisible = !_userPasswordVisible;
            });
          },
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildEmailFormField() {
    return TextFormField(
      validator: (input) {
        if (input.isEmpty) {
          return 'Enter your email';
        } else if (!RegExp(r'^.+@[ a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z ]+)$').hasMatch(input)) {
          return 'Enter valid email';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        _userModel.email = value;
      },
      decoration: const InputDecoration(
        labelText: 'Email',
        icon: Icon(
          Icons.email,
          color: Colors.black,
        ),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildProgressIndicatorOnScreen() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
      ),
    );
  }
}
