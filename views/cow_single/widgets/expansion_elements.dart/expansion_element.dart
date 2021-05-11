import 'package:cattle_scan/views/alerts/widgets/full_event_card.dart';
import 'package:cattle_scan/views/event_by_cow/cow_event_interactor.dart';
import 'package:cattle_scan/views/event_by_cow/models/cow_event_model_ui.dart';
import 'package:flutter/material.dart';

import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/components/safe_text/safe_text.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/alerts/alerts_interactor.dart';
import 'package:cattle_scan/views/alerts/models/alert_model_ui.dart';
import 'package:cattle_scan/views/alerts/widgets/full_alert_card.dart';

import '../../interactor_cow_single.dart';

part 'alert_page.dart';
part 'event_page.dart';

enum IncludeType {
  alerts,
  events,
}

class CustomExpansionPanel extends StatefulWidget {
  final int bolusId;
  final CowSingleInteractor cowSingleInteractor;
  final IncludeType includeType;

  final EventsInteractor eventsInteractor;

  const CustomExpansionPanel({
    Key key,
    @required this.bolusId,
    @required this.cowSingleInteractor,
    @required this.eventsInteractor,
    @required this.includeType,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _getCurrentPage();

  State<StatefulWidget> _getCurrentPage() {
    switch (includeType) {
      case IncludeType.alerts:
        return _ExpansionAlertPanelState();
        break;
      case IncludeType.events:
        return _ExpansionEventPanelState(eventsInteractor);
        break;
      default:
        return _EpsonPageState(includeType.toString());
    }
  }
}

class _EpsonPageState extends State<CustomExpansionPanel> {
  _EpsonPageState(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Don't create page with $text"),
    );
  }
}
