import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:flutter/material.dart';

class CheckForm extends StatelessWidget {
  final bool isOpen;
  final String title;
  final Widget child;
  final void Function(bool _) callBack;

  const CheckForm({
    Key key,
    this.callBack,
    this.isOpen,
    this.title = '',
    this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: DesignStile.buttonDecoration(
              offset: const Offset(0, 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  child: InkCustomButton(
                    onTap: () {
                      callBack(!isOpen ?? false);
                    },
                    child: Row(
                      children: [
                        Icon(isOpen ?? false ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded),
                        const SizedBox(width: 25),
                        Text(title),
                      ],
                    ),
                  ),
                ),
                child ?? Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
