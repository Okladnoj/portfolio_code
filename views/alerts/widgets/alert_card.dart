import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/components/logic/text_format.dart';
import 'package:cattle_scan/views/alerts/models/alert_model_ui.dart';
import 'package:cattle_scan/views/cows_list/models/cow_model.dart';
import 'package:cattle_scan/views/event_by_cow/cow_event_interactor.dart';
import 'package:cattle_scan/views/cow_single/interactor_cow_single.dart';
import 'package:cattle_scan/views/events_create/models/diagnose_model.dart';
import 'package:flutter/material.dart';

import '../../../components/formers/list_rich_text.dart';
import '../../../settings/constants.dart';
import '../alerts_interactor.dart';
import 'calvin_card.dart';

class CardOfAlert extends StatelessWidget {
  const CardOfAlert({
    Key key,
    @required this.alertModelUI,
    @required this.cowSingleInteractor,
    @required this.alertsInteractor,
    this.isInsideCow = false,
    this.eventsInteractor,
    this.isUnClickable = false,
    this.isTopPadding = true,
  }) : super(key: key);

  final AlertModelUI alertModelUI;
  final CowSingleInteractor cowSingleInteractor;
  final AlertsInteractor alertsInteractor;
  final bool isInsideCow;
  final EventsInteractor eventsInteractor;
  final bool isUnClickable;
  final bool isTopPadding;

  bool get _isCharts => alertModelUI?.listAlertModelUI?.isNotEmpty ?? false;

  @override
  Widget build(BuildContext context) {
    final void Function() onTap = isUnClickable
        ? null
        : () async {
            alertsInteractor.updateReadStatusForAlert(alertModelUI.id);
            if (isInsideCow) {
              AppNavigator.navigateToCreateFeedback(alertModelUI, 1, alertsInteractor, eventsInteractor);
            } else {
              AppNavigator.navigateToProvideFeedbackPage(
                  alertModelUI, _buildButtonCreateFeedBack(), cowSingleInteractor);
            }
          };
    Future<void> onCreateEvent() async {
      final cow = Cow(
        animalId: alertModelUI.cowId,
        bolusId: alertModelUI.bolusId,
      );
      AppNavigator.navigateToCreateEvent(
          Future.value([cow]), 1, alertModelUI, alertsInteractor, eventsInteractor, DiagnoseModel('FRESH', 'FRESH'));
    }

    return Hero(
      tag: alertModelUI.id,
      child: SizedBox(
        height: _isCharts ? 250 : 150,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: isTopPadding ? 10 : 0,
            bottom: !isTopPadding ? 10 : 0,
          ),
          child: _buildAlertContent(onTap, onCreateEvent),
        ),
      ),
    );
  }

  Widget _buildAlertContent(void Function() onTap, void Function() onCreateEvent) {
    if (_isCharts) {
      return _buildCalvinCard(onTap, onCreateEvent);
    } else {
      return _buildAlertMessage(onTap);
    }
  }

  Material _buildCalvinCard(void Function() onTap, void Function() onCreateEvent) {
    return Material(
      child: CalvinCard(
        alertModelUI: alertModelUI,
        onTap: onTap,
        onCreateEvent: onCreateEvent,
      ),
    );
  }

  Widget _buildAlertMessage(void Function() onTap) {
    return InkCustomButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: DesignStile.buttonDecoration(
          color: alertModelUI.isRead ? DesignStile.white : DesignStile.primary,
          colorBorder: DesignStile.primary,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGListRichText('Description: ', gMascCow(alertModelUI.message, alertModelUI.cowId)),
                _buildGListRichText('Status: ', alertModelUI.isRead ? 'Read' : 'Unread'),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: alertModelUI.isRead
                  ? const Icon(Icons.drafts_outlined, color: DesignStile.black)
                  : const Icon(Icons.mark_email_unread, color: DesignStile.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGListRichText(String string1, String string2) {
    return gListRichText([
      ModelRichText(
        string1,
        DesignStile.textStyleCustom(
          fontSize: 16,
          color: alertModelUI.isRead ? DesignStile.black : DesignStile.white,
        ),
      ),
      ModelRichText(
        string2,
        DesignStile.textStyleCustom(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: alertModelUI.isRead ? DesignStile.black : DesignStile.white,
        ),
      ),
    ]);
  }

  Widget _buildButtonCreateFeedBack() {
    const double borderRadius = 10;
    return Column(
      children: [
        Expanded(child: Container()),
        Hero(
          tag: alertModelUI.id,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 30,
                right: 15,
                left: 15,
              ),
              height: 100,
              child: InkCustomButton(
                borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
                onTap: () {
                  AppNavigator.navigateToCreateFeedback(alertModelUI, 2, alertsInteractor, eventsInteractor);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: const Alignment(0, 0),
                  decoration: DesignStile.buttonDecoration(
                    borderRadius: 10,
                    offset: const Offset(0, 2),
                    colorBoxShadow: DesignStile.primary,
                    blurRadius: borderRadius,
                    colorBorder: DesignStile.primary,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Provide Feedback',
                        style: DesignStile.textStyleCustom(
                          color: DesignStile.black,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        gMascCow(alertModelUI.message, alertModelUI.cowId),
                        textAlign: TextAlign.justify,
                        style: DesignStile.textStyleCustom(
                          color: DesignStile.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
