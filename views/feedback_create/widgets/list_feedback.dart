import 'package:cattle_scan/components/safe_text/safe_text.dart';
import 'package:cattle_scan/views/alerts/models/alert_model_ui.dart';
import 'package:flutter/material.dart';

import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/components/formers/list_rich_text.dart';

List<Widget> buildAlertsListFeedBack(
  List<FeedbackModelUI> _alertListFeedBack,
) {
  final List<FeedbackModelUI> alertListFeedBack = _alertListFeedBack;
  final List<Widget> items = [];

  if (alertListFeedBack.isNotEmpty) {
    // ignore: avoid_function_literals_in_foreach_calls
    alertListFeedBack.forEach((FeedbackModelUI alert) {
      items.add(
        Card(
          color: DesignStile.primary,
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                gListRichText([
                  ModelRichText('Data: ', gTextStyleBold),
                  ModelRichText(alert.created, gTextStyleBold),
                ]),
                gListRichText([
                  ModelRichText('Visual Symptoms: ', gTextStyleBold),
                  ModelRichText(alert.visualSymptoms ? 'Yes' : 'No', gTextStyleNormal),
                ]),
                gListRichText([
                  ModelRichText('Rectal Temperature: ', gTextStyleBold),
                  ModelRichText('${alert.rectalTemperature ?? '?'} C', gTextStyleNormal),
                ]),
                gListRichText([
                  ModelRichText('Rectal Temperature Measuring Time: ', gTextStyleBold),
                  ModelRichText(alert.rectalTemperatureTime, gTextStyleNormal),
                ]),
                gListRichText([
                  ModelRichText('Diagnosis defined: ', gTextStyleBold),
                  ModelRichText('''\n${alert.diagnosis ?? ''}''', gTextStyleNormal),
                ]),
                gListRichText([
                  ModelRichText('Treatment notes: ', gTextStyleBold),
                  ModelRichText('''\n${alert.treatmentNote ?? ''}''', gTextStyleNormal),
                ]),
                gListRichText([
                  ModelRichText('General notes: ', gTextStyleBold),
                  ModelRichText('''\n${alert.treatmentNote ?? ''}''', gTextStyleNormal),
                ]),
              ],
            ),
          ),
        ),
      );
    });

    items.add(
      const SizedBox(height: 20.0),
    );
  } else {
    items.add(
      Center(
        child: SafeText(
          null,
          style: DesignStile.textStyleCustom(
            color: DesignStile.black,
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  return items;
}
