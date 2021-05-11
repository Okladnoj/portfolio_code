import 'package:cattle_scan/components/formers/list_rich_text.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:flutter/material.dart';

import '../models/alert_model_ui.dart';

class CardOfEvent extends StatelessWidget {
  const CardOfEvent({
    Key key,
    @required this.event,
    this.isTopPadding = false,
  }) : super(key: key);

  final EventModelUI event;
  final bool isTopPadding;
  bool get isPresent => event?.id != null;

  @override
  Widget build(BuildContext context) {
    return isPresent
        ? Container(
            margin: EdgeInsets.only(
              top: isTopPadding ? 5 : 0,
              right: 20,
              left: 20,
              bottom: !isTopPadding ? 5 : 0,
            ),
            padding: const EdgeInsets.all(15.0),
            decoration: DesignStile.buttonDecoration(
              colorBorder: DesignStile.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                gListRichText([
                  ModelRichText('Name: ', gTextStyleBold),
                  ModelRichText(event?.name ?? '', gTextStyleNormal),
                ]),
                gListRichText([
                  ModelRichText('Date Event: ', gTextStyleBold),
                  ModelRichText(event?.date ?? '', gTextStyleNormal),
                ]),
                gListRichText([
                  ModelRichText('Event Type: ', gTextStyleBold),
                  ModelRichText(event?.eventType ?? '', gTextStyleNormal),
                ]),
                gListRichText([
                  ModelRichText('Protocols: ', gTextStyleBold),
                  ModelRichText(event?.protocols ?? '', gTextStyleNormal),
                ]),
                gListRichText([
                  ModelRichText('Remark: ', gTextStyleBold),
                  ModelRichText(event?.remark ?? '', gTextStyleNormal),
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
              'Event is epson',
              style: DesignStile.textStyleCustom(),
            ),
          );
  }
}
