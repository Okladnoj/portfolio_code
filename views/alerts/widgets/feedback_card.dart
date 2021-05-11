import 'package:cattle_scan/components/formers/list_rich_text.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:flutter/material.dart';

import '../models/alert_model_ui.dart';

class CardOfFeedback extends StatelessWidget {
  const CardOfFeedback({
    Key key,
    @required this.feedback,
  }) : super(key: key);

  final FeedbackModelUI feedback;
  bool get isPresent => feedback?.id != null;
  @override
  Widget build(BuildContext context) {
    return isPresent
        ? Container(
            margin: const EdgeInsets.only(bottom: 5, right: 20, left: 20),
            padding: const EdgeInsets.all(15.0),
            decoration: DesignStile.buttonDecoration(colorBorder: DesignStile.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                gListRichText([
                  ModelRichText('Data: ', gTextStyleBold),
                  ModelRichText(feedback?.created, gTextStyleBold),
                ]),
                gListRichText([
                  ModelRichText('Visual Symptoms: ', gTextStyleBold),
                  ModelRichText((feedback?.visualSymptoms ?? false) ? 'Yes' : 'No', gTextStyleNormal),
                ]),
                gListRichText([
                  ModelRichText('Rectal Temperature: ', gTextStyleBold),
                  ModelRichText('${feedback?.rectalTemperature ?? ''}\u2103', gTextStyleNormal),
                ]),
                gListRichText([
                  ModelRichText('Rectal Temperature Measuring Time: ', gTextStyleBold),
                  ModelRichText(feedback?.rectalTemperatureTime ?? '', gTextStyleNormal),
                ]),
                gListRichText([
                  ModelRichText('Diagnosis defined: ', gTextStyleBold),
                  ModelRichText('''\n${feedback?.diagnosis ?? ''}''', gTextStyleNormal),
                ]),
                gListRichText([
                  ModelRichText('Treatment notes: ', gTextStyleBold),
                  ModelRichText('''\n${feedback?.treatmentNote ?? ''}''', gTextStyleNormal),
                ]),
                gListRichText([
                  ModelRichText('General notes: ', gTextStyleBold),
                  ModelRichText('''\n${feedback?.generalNote ?? ''}''', gTextStyleNormal),
                ]),
              ],
            ),
          )
        : Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 5, right: 20, left: 20),
            padding: const EdgeInsets.all(15.0),
            decoration: DesignStile.buttonDecoration(colorBorder: DesignStile.primary),
            alignment: const Alignment(0, 0),
            child: Text(
              'Feedback is epson',
              style: DesignStile.textStyleCustom(),
            ),
          );
  }
}
