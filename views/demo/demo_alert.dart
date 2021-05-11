import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:flutter/material.dart';

class DemoAlert extends StatefulWidget {
  const DemoAlert({
    Key key,
  }) : super(key: key);

  @override
  _DemoAlertState createState() => _DemoAlertState();
}

class _DemoAlertState extends State<DemoAlert> {
  @override
  Widget build(BuildContext context) {
    final heightFull = MediaQuery.of(context).size.height;
    const double height = 250;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          margin:
              EdgeInsets.only(left: 10, right: 10, top: (heightFull - height) / 2, bottom: (heightFull - height) / 2),
          decoration: DesignStile.buttonDecoration(
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              _buildDescribe(),
              _buildActionsButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        'On Farm Trial',
        textAlign: TextAlign.right,
        style: DesignStile.textStyleCustom(
          color: DesignStile.dark,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildDescribe() {
    return Text(
      'Our Customer Success team will contact you to discuss an on on-farm trial.' +
          '\n\nPlease click on send request to request an on-farm trial.',
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontFamily: DesignStile.listNamesOfFont[NamesOfFont.nunito],
        height: 1,
        color: DesignStile.dark,
        fontWeight: FontWeight.w300,
        fontSize: 16,
      ),
    );
  }

  Widget _buildActionsButton() {
    final List<Widget> children = [];

    children.add(_buildButton(
      data: 'Send Request',
      color: DesignStile.primary,
      colorText: DesignStile.white,
      width: 150,
      onTap: () => Navigator.of(context).pop(false),
    ));

    children.add(_buildButton(
      data: 'Close',
      color: DesignStile.white,
      colorText: DesignStile.dark,
      onTap: () => Navigator.of(context).pop(true),
    ));

    final MainAxisAlignment mainAxisAlignment = children.length > 1 //
        ? MainAxisAlignment.spaceBetween
        : MainAxisAlignment.center;

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: children,
    );
  }

  Widget _buildButton({
    String data,
    Function() onTap,
    Color color,
    Color colorText,
    double width = 100,
  }) {
    const double height = 45;
    return InkCustomButton(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(height / 2),
      onTap: onTap,
      child: Container(
        alignment: const Alignment(0, 0),
        decoration: DesignStile.buttonDecoration(
          color: color,
          blurRadius: 10,
          borderRadius: height / 2,
          offset: const Offset(0, 1),
          colorBoxShadow: DesignStile.grey,
          colorBorder: color,
        ),
        child: Text(
          data,
          textAlign: TextAlign.center,
          style: DesignStile.textStyleCustom(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: colorText,
          ),
        ),
      ),
    );
  }
}
