import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/views/cows_list/Interactor_cows_list.dart';
import 'package:cattle_scan/views/cows_list/data/load_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/buttons/toggle_button.dart';
import '../../components/formers/custom_list_title.dart';
import '../../components/formers/screen_former.dart';
import '../../components/safe_text/safe_text.dart';
import '../../settings/constants.dart';
import '../alerts/alerts_page.dart';
import '../alerts/domain/filter_model.dart';
import 'home_interactor.dart';
import 'home_page_right_sheet.dart';
import 'models/home_model.dart';
import 'models/home_model_ui.dart';
import 'models/right_sheet_model.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'HomeScreen';

  const HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  StateRightSheet _stateRightSheet;
  HomeInteractor _homeInteractor;
  HomeModelUI _homeModelUI;
  StateToggle _stateToggle;

  bool get isWeek => _homeModelUI?.currentPeriod == CurrentPeriod.week;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    CowsListInteractor();
    _homeInteractor = HomeInteractor();
    _stateToggle = StateToggle.non;
    _stateRightSheet = StateRightSheet(300, true, true);
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _homeInteractor.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("AppLifecycleState: $state <------------------");
    if (AppLifecycleState.resumed == state) {
      _homeInteractor.updateInfo();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: StreamBuilder<HomeModelUI>(
          stream: _homeInteractor.observer,
          builder: (context, snapshot) {
            _homeModelUI = snapshot?.data ?? _homeModelUI;
            return Stack(
              children: [
                ScreenFormer(
                  titleActions: _buildTitleActions(),
                  children: [
                    _buildFarmInfo(),
                    _buildSwitchPeriod(),
                    _buildMonitorButtons(),
                    _buildToggleButtons(),
                    _buildListConsumer(),
                    _buildListOfCows(),
                    _buildHerdCharts(),
                    _buildCreateEvent(),
                  ],
                ),
                CustomRightSheet(
                  key: ValueKey(_stateRightSheet.refreshKey),
                  isWeek: ValueNotifier(_homeModelUI?.currentPeriod == CurrentPeriod.week),
                  stateRightSheet: _stateRightSheet.copy(width: MediaQuery.of(context).size.width - 65),
                  callBackStateRightSheet: (stateRightSheet) {
                    //
                    _stateRightSheet = stateRightSheet;
                  },
                )
              ],
            );
          }),
    );
  }

  Row _buildTitleActions() {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: InkCustomButton(
            onTap: () {
              setState(() {
                _stateRightSheet = _stateRightSheet.copy(
                  isOpen: !_stateRightSheet.isOpen,
                  refreshKey: !_stateRightSheet.refreshKey,
                );
              });
            },
            child: Container(
              color: const Color(0x00000000),
              child: const Icon(
                Icons.list,
                size: 36,
                color: DesignStile.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          'Home',
          style: DesignStile.textStyleCustom(
            fontSize: 22,
            color: DesignStile.white,
            fontWeight: FontWeight.w900,
            isHeadline: true,
          ),
        ),
        Expanded(child: Container()),
        InkCustomButton(
          height: 40,
          width: 40,
          onTap: () {
            AppNavigator.navigateToAboutAppPage();
          },
          child: const Icon(
            Icons.help_outline_outlined,
            size: 36,
            color: DesignStile.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFarmInfo() {
    String seenCow;
    if (_homeModelUI?.currentPeriod == CurrentPeriod.week) {
      seenCow = 'Seen in 7 days';
    } else {
      seenCow = 'Seen in 24 hrs';
    }
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: DesignStile.transparent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildNameFarm(),
          Row(
            children: [
              _buildUpMonitor(_homeModelUI?.activeCows, 'Active cows'),
              _buildUpMonitor(_homeModelUI?.in24Seen, seenCow),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNameFarm() {
    return SafeText(
      _homeModelUI?.farmName,
      style: DesignStile.textStyleCustom(
        fontSize: 28,
        color: DesignStile.black,
        // ignore: avoid_redundant_argument_values
        fontWeight: FontWeight.w700,
        isHeadline: true,
      ),
    );
  }

  Widget _buildUpMonitor(int info, String describe) {
    return Expanded(
      child: Column(
        children: [
          SafeText(
            info,
            style: DesignStile.textStyleCustom(
              fontSize: 72,
              color: DesignStile.black.withOpacity(0.8),
              // ignore: avoid_redundant_argument_values
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            describe,
            style: DesignStile.textStyleCustom(
              fontSize: 16,
              color: DesignStile.black.withOpacity(0.65),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonitorButtons() {
    final _height = (MediaQuery.of(context).size.width - _kSizeMonitorButton.width * 2) / 3;

    final List<Widget> child = [
      _buildMonitorInfo(_homeModelUI?.highTemp, (nameScreen) => _tapOnHighTemp(nameScreen)),
      _buildMonitorInfo(_homeModelUI?.sustainTemp, (nameScreen) => _tapOnSustainTemp(nameScreen)),
      _buildMonitorInfo(_homeModelUI?.calving, (nameScreen) => _tapOnCalving(nameScreen)),
      _buildMonitorInfo(_homeModelUI?.waterIntake, (nameScreen) => _tapOnWaterIntake(nameScreen)),
    ];
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        SizedBox(height: _height),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _buildMonitorButton(child[0]),
          _buildMonitorButton(child[1]),
        ]),
        SizedBox(height: _height),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _buildMonitorButton(child[2]),
          _buildMonitorButton(child[3]),
        ]),
        SizedBox(height: _height),
      ],
    );
  }

  Widget _buildSwitchPeriod() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonSwitchPeriod('24 hrs', !isWeek, _switchToDay),
          _buildButtonSwitchPeriod('7 days', isWeek, _switchToWeek),
        ],
      ),
    );
  }

  void _switchToDay() => _homeInteractor.switchTimePeriod(CurrentPeriod.in24);

  void _switchToWeek() => _homeInteractor.switchTimePeriod(CurrentPeriod.week);

  SizedBox _buildButtonSwitchPeriod(String string, bool isActive, void Function() onTap) {
    return SizedBox(
      height: 35,
      width: 140,
      child: InkCustomButton(
        onTap: onTap,
        child: Container(
          alignment: const Alignment(0, 0),
          decoration: DesignStile.buttonDecoration(
            color: isActive ? DesignStile.primary : DesignStile.grey,
            colorBorder: isActive ? DesignStile.primary : DesignStile.grey,
            offset: const Offset(0, 2),
          ),
          child: Text(
            string,
            style: DesignStile.textStyleCustom(
              color: isActive ? DesignStile.white : DesignStile.disable,
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonitorInfo(MonitorModelUI highTemp, void Function(String nameScreen) onTap) {
    return InkCustomButton(
      onTap: () => onTap(highTemp?.name),
      child: Stack(
        alignment: const Alignment(0, 0),
        children: [
          SafeText(
            highTemp?.value,
            style: DesignStile.textStyleCustom(
              fontSize: 72,
              color: DesignStile.primary.withOpacity(0.8),
              // ignore: avoid_redundant_argument_values
              fontWeight: FontWeight.w700,
            ),
          ),
          Positioned(
            bottom: 2,
            child: SafeText(
              highTemp?.name,
              style: DesignStile.textStyleCustom(
                fontSize: 16,
                // ignore: avoid_redundant_argument_values
                color: DesignStile.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonitorButton(Widget child) {
    return Container(
      height: _kSizeMonitorButton.height,
      width: _kSizeMonitorButton.width,
      decoration: DesignStile.buttonDecoration(colorBorder: DesignStile.primary),
      child: child,
    );
  }

  Widget _buildToggleButtons() {
    final _margin = (MediaQuery.of(context).size.width - _kSizeMonitorButton.width * 2) / 3;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _margin),
      child: DesignSwitchToggle(
        key: ValueKey(_stateToggle != StateToggle.non),
        stateToggle: _stateToggle,
        callBack: (stateToggle) {
          setState(() {
            _stateToggle = stateToggle;
            print(stateToggle);
          });
        },
      ),
    );
  }

  Widget _buildListConsumer() {
    final List<Widget> _listInfo = _stateToggle == StateToggle.first
        ? _homeModelUI?.groups?.map((e) => _buildRowInfo(e))?.toList()
        : _stateToggle == StateToggle.second
            ? _homeModelUI?.lactationStages?.map((e) => _buildRowInfo(e))?.toList()
            : [];
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: _listInfo ?? [],
      ),
    );
  }

  Widget _buildRowInfo(e) {
    final _margin = (MediaQuery.of(context).size.width - _kSizeMonitorButton.width * 2) / 3;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _margin, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: SafeText(
                e?.name,
                style: DesignStile.textStyleCustom(
                  fontSize: 18,
                  color: DesignStile.black.withOpacity(0.65),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SafeText(
                e?.value,
                style: DesignStile.textStyleCustom(
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListOfCows() {
    return CustomListTitle(
      icon: Icons.list,
      data: 'List of cows',
      onTap: _onTapListOfCows,
    );
  }

  Widget _buildHerdCharts() {
    return CustomListTitle(
      icon: Icons.leaderboard,
      data: 'Herd charts',
      onTap: _onTapHerdCharts,
    );
  }

  Widget _buildCreateEvent() {
    return CustomListTitle(
      icon: Icons.calendar_today,
      data: 'Create event',
      onTap: _onTapCreateEvent,
    );
  }

  void _onTapListOfCows() {
    AppNavigator.navigateToCowsListPage();
  }

  void _onTapHerdCharts() {
    AppNavigator.navigateToHerdChartsPage();
  }

  void _onTapCreateEvent() {
    AppNavigator.navigateToCreateEvent(getCowsList(), 1);
  }

  void _tapOnHighTemp(String nameScreen) {
    final timePeriod = isWeek ? 'week' : '24h';
    final filterToAlerts = FilterToAlerts(
      nameScreen: nameScreen,
      key: 'getTodayAlertListByEvent',
      listKeys: ['Q41', timePeriod],
    );
    _navigateToAlerts(filterToAlerts);
  }

  void _tapOnSustainTemp(String nameScreen) {
    final timePeriod = isWeek ? 'week' : '24h';
    final filterToAlerts = FilterToAlerts(
      nameScreen: nameScreen,
      key: 'getTodayAlertListByEvent',
      listKeys: ['Q40.5', timePeriod],
    );
    _navigateToAlerts(filterToAlerts);
  }

  void _tapOnLowTemp(String nameScreen) {
    final timePeriod = isWeek ? 'week' : '24h';
    final filterToAlerts = FilterToAlerts(
      nameScreen: nameScreen,
      key: 'getTodayAlertListByEvent',
      listKeys: ['CIH', timePeriod],
    );
    _navigateToAlerts(filterToAlerts);
  }

  void _tapOnWaterIntake(String nameScreen) {
    final timePeriod = isWeek ? 'week' : '24h';
    final filterToAlerts = FilterToAlerts(
      nameScreen: nameScreen,
      key: 'getTodayAlertListByEvent',
      listKeys: ['WI20', timePeriod],
    );
    _navigateToAlerts(filterToAlerts);
  }

  void _tapOnCalving(String nameScreen) {
    final timePeriod = isWeek ? 'week' : '24h';
    final filterToAlerts = FilterToAlerts(
      nameScreen: nameScreen,
      key: 'getTodayAlertListByEvent',
      listKeys: ['CIH', timePeriod],
    );
    _navigateToAlerts(filterToAlerts);
  }

  void _navigateToAlerts(FilterToAlerts filterToAlerts) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlertsPage(filterToAlerts: filterToAlerts, isInsideCow: false)),
    );
  }

  static const _kSizeMonitorButton = Size(150, 150);
}

Future<bool> _onWillPop() async {
  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  return Future.value(false);
}
