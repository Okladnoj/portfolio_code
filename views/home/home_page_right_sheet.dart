import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/views/alerts/alerts_page.dart';
import 'package:cattle_scan/views/alerts/domain/filter_model.dart';
import 'package:cattle_scan/views/cows_list/data/load_data.dart';
import 'package:cattle_scan/views/sing_in/domain/sing_in_functions.dart';
import 'package:flutter/material.dart';

import '../../settings/constants.dart';
import 'models/right_sheet_model.dart';

typedef CallBackStateRightSheet = Function(StateRightSheet stateRightSheet);

class CustomRightSheet extends StatefulWidget {
  const CustomRightSheet({
    ValueKey<bool> key,
    @required StateRightSheet stateRightSheet,
    @required CallBackStateRightSheet callBackStateRightSheet,
    @required this.isWeek,
  })  : _stateRightSheet = stateRightSheet,
        _callBackStateRightSheet = callBackStateRightSheet,
        super(key: key);

  final StateRightSheet _stateRightSheet;
  final CallBackStateRightSheet _callBackStateRightSheet;

  final ValueNotifier<bool> isWeek;
  @override
  _CustomRightSheetState createState() => _CustomRightSheetState();
}

class _CustomRightSheetState extends State<CustomRightSheet> with SingleTickerProviderStateMixin {
  StateRightSheet _stateRightSheet;
  Animation<double> animation;
  AnimationController controller;
  CallBackStateRightSheet _callBackStateRightSheet;
  final Duration _duration = const Duration(milliseconds: 800);
  bool get isVisible => (animation?.value ?? 0) > 0;

  @override
  void initState() {
    _stateRightSheet = widget._stateRightSheet;
    _callBackStateRightSheet = widget._callBackStateRightSheet;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initControllers();
  }

  @override
  void dispose() {
    controller.dispose();
    animation.removeListener(() {});

    super.dispose();
  }

  void _initControllers() {
    final double widthMax = _stateRightSheet.width;
    final double end = _stateRightSheet.isOpen ? 0 : widthMax;
    controller = AnimationController(
      duration: _duration,
      vsync: this,
    );
    animation =
        Tween<double>(begin: 0, end: end).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOutBack))
          ..addListener(() {
            setState(() {
              if (animation.isDismissed) {
                _callBackStateRightSheet(_stateRightSheet.copy(
                  width: 0,
                  isOpen: true,
                ));
              } else if (animation.isCompleted) {
                _callBackStateRightSheet(_stateRightSheet.copy(
                  width: 0,
                  isOpen: true,
                ));
              }
            });
          });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Row(
        children: [
          Container(
            color: DesignStile.white,
            height: double.maxFinite,
            width: animation.value,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    child: Scaffold(
                      body: ListView(
                        children: [
                          _buildLogo(),
                          _buildButtonNavigator(
                            Icons.list,
                            'List of cows',
                            () {
                              AppNavigator.navigateToCowsListPage();
                            },
                          ),
                          _buildButtonNavigator(
                            Icons.list,
                            'List of alerts',
                            () {
                              List<String> listKeys;
                              if (widget?.isWeek?.value ?? false) {
                                listKeys = ['week'];
                              } else {
                                listKeys = ['24h'];
                              }
                              _navigateToAlerts(
                                FilterToAlerts(nameScreen: 'Today Alerts', key: 'alertListFarm', listKeys: listKeys),
                              );
                            },
                          ),
                          _buildButtonNavigator(
                            Icons.calendar_today_outlined,
                            'Create an event',
                            () {
                              _onTapCreateEvent();
                            },
                          ),
                          _buildButtonNavigator(
                            Icons.info_outlined,
                            'About the app',
                            () {
                              AppNavigator.navigateToAboutAppPage();
                            },
                          ),
                          _buildButtonNavigator(
                            Icons.settings,
                            'Settings for App',
                            () {
                              AppNavigator.navigateToAppSettingPage();
                            },
                          ),
                          _buildButtonNavigator(
                            Icons.exit_to_app_rounded,
                            'Logout',
                            () {
                              gSingOut();
                            },
                          ),
                          const SizedBox(height: 25),
                          _buildButtonNavigator(
                            Icons.bug_report_outlined,
                            'Report Issues',
                            () {
                              AppNavigator.navigateToIssuesReportPage();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: InkCustomButton(
              onTap: () {
                _stateRightSheet.copy(
                  isOpen: !_stateRightSheet.isOpen,
                );
                controller.reverse();
              },
              child: Container(
                color: const Color(0x55000000),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onTapCreateEvent() {
    AppNavigator.navigateToCreateEvent(getCowsList(), 1);
  }

  Container _buildButtonNavigator(
    IconData icon,
    String nameButton,
    Function() onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 40,
      decoration: DesignStile.buttonDecoration(offset: const Offset(0, 3)),
      child: InkCustomButton(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          alignment: Alignment.center,
          child: Row(
            children: [
              Icon(
                icon,
                color: DesignStile.primary,
                size: 30,
              ),
              const SizedBox(width: 30),
              Text(
                nameButton,
                style: DesignStile.textStyleCustom(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: DesignStile.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _buildIconNavigator(
    IconData icon,
    Function() onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 50,
      width: 50,
      decoration: DesignStile.buttonDecoration(offset: const Offset(0, 3)),
      child: InkCustomButton(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: DesignStile.primary,
            size: 40,
          ),
        ),
      ),
    );
  }

  Container _buildLogo() {
    return Container(
      height: 250,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: DesignStile.transparent,
          ),
        ),
      ),
      child: Image.asset(
        'assets/images/logo_circle.gif',
        fit: BoxFit.contain,
      ),
    );
  }

  void _navigateToAlerts(FilterToAlerts filterToAlerts) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AlertsPage(
                filterToAlerts: filterToAlerts,
                isInsideCow: false,
              )),
    );
  }
}
