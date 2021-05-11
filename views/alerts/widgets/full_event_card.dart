import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/alerts/widgets/alert_card.dart';
import 'package:flutter/material.dart';

import '../models/alert_model_ui.dart';
import 'event_card.dart';
import 'full_alert_card.dart';

class FullEventCard extends StatefulWidget {
  const FullEventCard({
    Key key,
    @required this.eventModelUI,
    @required this.isInsideCow,
    @required this.alertModelUI,
  }) : super(key: key);
  final AlertModelUI alertModelUI;
  final EventModelUI eventModelUI;
  final bool isInsideCow;
  @override
  _FullEventCardState createState() => _FullEventCardState();
}

class _FullEventCardState extends State<FullEventCard> {
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
        CardOfEvent(
          event: widget.eventModelUI,
          isTopPadding: true,
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
          _buildButtonExpandedCard('Alert ', OpenElement.event),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(),
          ),
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
      if (widget.eventModelUI?.alerts?.isNotEmpty ?? false) {
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
    final alert = widget.alertModelUI;
    if (_openElement == OpenElement.event) {
      return CardOfAlert(
        alertModelUI: alert,
        cowSingleInteractor: null,
        alertsInteractor: null,
        isUnClickable: true,
        isTopPadding: false,
      );
    }
    return Container();
  }
}
