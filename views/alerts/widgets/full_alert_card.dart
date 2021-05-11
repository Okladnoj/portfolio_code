import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/alerts/models/alert_model_ui.dart';
import 'package:cattle_scan/views/event_by_cow/cow_event_interactor.dart';
import 'package:cattle_scan/views/cow_single/interactor_cow_single.dart';
import 'package:flutter/material.dart';

import '../alerts_interactor.dart';
import 'alert_card.dart';
import 'event_card.dart';
import 'feedback_card.dart';

enum OpenElement {
  event,
  feedback,
  alert,
}

class FullAlertCard extends StatefulWidget {
  const FullAlertCard({
    Key key,
    @required this.alertModelUI,
    @required this.cowSingleInteractor,
    @required this.alertsInteractor,
    @required this.isInsideCow,
    this.eventsInteractor,
  }) : super(key: key);

  final AlertModelUI alertModelUI;
  final CowSingleInteractor cowSingleInteractor;
  final AlertsInteractor alertsInteractor;
  final bool isInsideCow;
  final EventsInteractor eventsInteractor;
  @override
  _FullAlertCardState createState() => _FullAlertCardState();
}

class _FullAlertCardState extends State<FullAlertCard> {
  final double _heightButton = 30;
  OpenElement _openElement;

  @override
  void initState() {
    _openElement = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        CardOfAlert(
          isInsideCow: widget.isInsideCow,
          alertModelUI: widget.alertModelUI,
          cowSingleInteractor: widget.cowSingleInteractor,
          alertsInteractor: widget.alertsInteractor,
          eventsInteractor: widget.eventsInteractor,
        ),
        _buildExpansionButtons(),
        _buildOpenedElement(),
      ],
    );
  }

  Widget _buildExpansionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          _buildButtonExpandedCard('Event', OpenElement.event),
          const SizedBox(
            width: 10,
          ),
          _buildButtonExpandedCard('Feedback', OpenElement.feedback),
        ],
      ),
    );
  }

  Widget _buildButtonExpandedCard(String nameButton, OpenElement openElement) {
    bool hasItem = true;
    Color colorButton;
    Color colorText;
    final bool isOpen = openElement == _openElement;
    final BorderRadius borderRadius = BorderRadius.only(
      bottomLeft: isOpen ? const Radius.circular(0) : Radius.elliptical(_heightButton * 2, _heightButton),
      bottomRight: isOpen ? const Radius.circular(0) : Radius.circular(_heightButton / 2),
      topRight: !isOpen ? const Radius.circular(0) : Radius.elliptical(_heightButton * 2, _heightButton),
      topLeft: !isOpen ? const Radius.circular(0) : Radius.circular(_heightButton / 2),
    );

    if (openElement == OpenElement.event) {
      if (widget.alertModelUI?.event?.id != null) {
        colorButton = DesignStile.white;
        colorText = DesignStile.primary;
      } else {
        colorButton = DesignStile.grey;
        colorText = DesignStile.disable;
        hasItem = false;
      }
    } else if (openElement == OpenElement.feedback) {
      if (widget.alertModelUI?.feedback?.id != null) {
        colorButton = DesignStile.white;
        colorText = DesignStile.primary;
      } else {
        colorButton = DesignStile.grey;
        colorText = DesignStile.disable;
        hasItem = false;
      }
    }

    return Expanded(
      child: hasItem
          ? Center(
              child: InkCustomButton(
                height: _heightButton,
                borderRadius: borderRadius,
                onTap: () {
                  //
                  setState(() {
                    if (openElement == _openElement) {
                      _openElement = null;
                    } else {
                      _openElement = openElement;
                    }
                  });
                },
                child: Container(
                    alignment: const Alignment(0, 0),
                    height: _heightButton,
                    decoration: BoxDecoration(
                      color: colorButton,
                      borderRadius: borderRadius,
                      border: Border.all(color: DesignStile.primary),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          nameButton,
                          style: DesignStile.textStyleCustom(color: colorText),
                        ),
                        Icon(
                          isOpen ? Icons.unfold_less_rounded : Icons.unfold_more_rounded,
                          color: colorText,
                        ),
                      ],
                    )),
              ),
            )
          : Container(),
    );
  }

  Widget _buildOpenedElement() {
    final event = widget.alertModelUI?.event;
    final feedback = widget.alertModelUI?.feedback;
    if (_openElement == OpenElement.event) {
      return CardOfEvent(event: event);
    } else if (_openElement == OpenElement.feedback) {
      return CardOfFeedback(feedback: feedback);
    }
    return Container();
  }
}
