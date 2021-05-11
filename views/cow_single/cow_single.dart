import 'package:cattle_scan/components/buttons/toggle_button.dart';
import 'package:cattle_scan/components/buttons/two_switch_button.dart';
import 'package:cattle_scan/components/safe_text/safe_text.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/cow_update/cow_update_page.dart';
import 'package:cattle_scan/views/event_by_cow/cow_event_interactor.dart';
import "package:flutter/material.dart";

import 'interactor_cow_single.dart';
import 'models/cow_single_ui.dart';
import 'widgets/chart_of_temperature.dart';
import 'widgets/chart_of_water.dart';
import 'widgets/expansion_elements.dart/expansion_element.dart';

class CowSinglePage extends StatefulWidget {
  const CowSinglePage({
    Key key,
    @required this.animalId,
    @required this.bolusId,
    @required this.cowSingleInteractor,
    this.feedbackButton,
  }) : super(key: key);

  static const id = 'CowSinglePage';

  final int animalId;
  final int bolusId;
  final CowSingleInteractor cowSingleInteractor;
  final Widget feedbackButton;

  @override
  _CowSinglePageState createState() => _CowSinglePageState();
}

class _CowSinglePageState extends State<CowSinglePage> {
  CowSingleModelUI _cowSingleModelUI;
  StateTimeInterval _selectedFilter;
  CowSingleInteractor _cowSingleInteractor;
  EventsInteractor eventsInteractor;

  @override
  void initState() {
    super.initState();
    eventsInteractor = EventsInteractor(widget.bolusId);
    _cowSingleInteractor = widget.cowSingleInteractor;
    _cowSingleInteractor.updateUI();
    _cowSingleInteractor.updateDataOfDayAndWeek(widget.animalId, widget.bolusId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Cow ${widget.animalId * DesignStile.maskCode}',
          style: DesignStile.textStyleAppBar,
        ),
      ),
      body: Stack(
        children: [
          _buildContent(),
          widget.feedbackButton ?? Container(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return StreamBuilder<Map<int, CowSingleModelUI>>(
        stream: _cowSingleInteractor.observer,
        builder: (context, snapshot) {
          try {
            _cowSingleModelUI = snapshot?.data[widget.animalId];
          } catch (e) {
            print(e);
          }

          _cowSingleModelUI?.selectedFilter = _selectedFilter = _selectedFilter ?? _cowSingleModelUI?.selectedFilter;
          StateToggle stateToggle;
          if (_selectedFilter == StateTimeInterval.today) {
            stateToggle = StateToggle.first;
          } else {
            stateToggle = StateToggle.second;
          }

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTwoSwitchButton(stateToggle),
                  const SizedBox(height: 15.0),
                  _buildRowInTitleStatus('Lactation stage: ', _cowSingleModelUI?.lactationStage),
                  const SizedBox(height: 15.0),
                  _buildRowInTitleStatus('Days in milk: ', _cowSingleModelUI?.daysInMilk),
                  const SizedBox(height: 15.0),
                  _buildRowInTitleStatus('Current lactation: ', _cowSingleModelUI?.currentLactation),
                  ...listDueDate(),
                  const SizedBox(height: 15.0),
                  _buildButtonForUpdateCowInfo(context),
                  const SizedBox(height: 20.0),
                  ChartOfTemperature(cowSingleModelUI: _cowSingleModelUI),
                  const SizedBox(height: 50.0),
                  ChartOfWater(cowSingleModelUI: _cowSingleModelUI),
                  const SizedBox(height: 50.0),
                  _buildExpansionsItems(),
                  const SizedBox(height: 150.0),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildTwoSwitchButton(StateToggle stateToggle) {
    return TwoSwitchButton(
      stateToggle: stateToggle,
      key: ValueKey(_selectedFilter == StateTimeInterval.today),
      title1: 'Today',
      title2: 'Week',
      callBack: (stateToggle) {
        setState(() {
          if (stateToggle == StateToggle.first) {
            _selectedFilter = StateTimeInterval.today;
          } else {
            _selectedFilter = StateTimeInterval.week;
          }
        });
      },
    );
  }

  List<Widget> listDueDate() {
    return ['PREG', 'DRY'].contains(_cowSingleModelUI?.lactationStage?.toUpperCase())
        ? [const SizedBox(height: 15.0), _buildRowInTitleStatus('Due Date: ', _cowSingleModelUI?.due)]
        : [];
  }

  Widget _buildButtonForUpdateCowInfo(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: DesignStile.primary,
      ),
      onPressed: () async {
        final shouldUpdate = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CowSingleUpdateInfoPage(
              animalId: widget.animalId,
              bolusId: widget.bolusId,
              currentLactation: _cowSingleModelUI?.currentLactation,
              lactationStage: _cowSingleModelUI?.lactationStage,
            ),
            fullscreenDialog: true,
          ),
        );

        if (shouldUpdate == true) {
          // _getInfo();
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Text(
          'Update information of this cow',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRowInTitleStatus(String name, String value) {
    return SizedBox(
      height: 20,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: value == null ? 30 : null,
            child: SafeText(
              value,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionsItems() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        CustomExpansionPanel(
          bolusId: widget.bolusId,
          cowSingleInteractor: _cowSingleInteractor,
          includeType: IncludeType.alerts,
          eventsInteractor: eventsInteractor,
        ),
        const SizedBox(
          height: 10,
        ),
        CustomExpansionPanel(
          bolusId: widget.bolusId,
          cowSingleInteractor: _cowSingleInteractor,
          includeType: IncludeType.events,
          eventsInteractor: eventsInteractor,
        ),
      ],
    );
  }
}
