import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/components/safe_text/safe_text.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:flutter/material.dart';

class TitleAlerts extends StatelessWidget {
  final String nameTitle;
  final Future<void> Function() subBackFunction;

  const TitleAlerts({
    Key key,
    @required this.nameTitle,
    this.subBackFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(0, 0),
      children: [
        Row(
          children: [
            _buildPopButton(context),
          ],
        ),
        _buildNameTitle(),
      ],
    );
  }

  Widget _buildNameTitle() {
    return SafeText(
      nameTitle,
      style: DesignStile.textStyleCustom(
        fontSize: 22,
        color: DesignStile.white,
        fontWeight: FontWeight.w900,
        isHeadline: true,
      ),
    );
  }

  Widget _buildPopButton(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: InkCustomButton(
        onTap: () async {
          if (subBackFunction != null) {
            await subBackFunction();
          }

          Navigator.of(context).pop();
        },
        child: Container(
          color: const Color(0x00000000),
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 36,
            color: DesignStile.white,
          ),
        ),
      ),
    );
  }
}
