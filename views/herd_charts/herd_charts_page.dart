import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/components/formers/screen_former.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/alerts/widgets/title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

import 'herd_charts_interactor.dart';
import 'models/collection.dart';
import 'models/herd_charts_model_ui.dart';
import 'widgets/chart_card_of_temperature.dart';
import 'widgets/chart_card_of_water.dart';

class HerdChartsPage extends StatefulWidget {
  static const String id = 'HerdChartsPage';

  const HerdChartsPage({Key key}) : super(key: key);
  @override
  _HerdChartsPageState createState() => _HerdChartsPageState();
}

class _HerdChartsPageState extends State<HerdChartsPage> {
  HerdChartsInteractor _herdChartsInteractor;
  HerdChartsModelUI _herdChartsModelUI;

  @override
  void initState() {
    super.initState();
    _herdChartsInteractor = HerdChartsInteractor();
  }

  @override
  void dispose() {
    _herdChartsInteractor?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFormer(
      titleActions: _buildTitleAlerts(),
      children: [
        _buildContent(),
      ],
    );
  }

  TitleAlerts _buildTitleAlerts() {
    return const TitleAlerts(nameTitle: 'Herd charts');
  }

  Widget _buildContent() {
    return StreamBuilder<HerdChartsModelUI>(
      stream: _herdChartsInteractor.observer,
      builder: (context, snapshot) {
        _herdChartsModelUI = snapshot?.data ?? _herdChartsModelUI;
        return Column(
          children: [
            _buildDivider(),
            _buildTableTitle('Herd Temperature Chart', WeatherIcons.thermometer),
            _buildSwitchDayHoursTemperature(),
            ChartCardOfTemperature(
              herdChartsModelUI: _herdChartsModelUI,
            ),
            _buildSwitchGroupLactationsTemperature(),
            _buildDivider(),
            _buildTableTitle('Herd Water Chart', WeatherIcons.raindrop),
            _buildSwitchDayHoursWater(),
            ChartCardOfWater(
              herdChartsModelUI: _herdChartsModelUI,
            ),
            _buildSwitchGroupLactationsWater(),
            _buildDivider(),
          ],
        );
      },
    );
  }

  Widget _buildTableTitle(String text, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      alignment: const Alignment(0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(
            text,
            style: DesignStile.textStyleCustom(
              color: DesignStile.dark,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchDayHoursTemperature() {
    final date = _herdChartsModelUI?.temperature?.date ?? DateTime.now();
    final isDay = _herdChartsModelUI?.temperature?.timeInterval == TimeInterval.day;
    final f = DateFormat('MMM, yyyy');
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildSwitchButton(
                'DAY',
                isDay,
                () {
                  _herdChartsInteractor.switchDayHoursTemperature(TimeInterval.day);
                },
              ),
              const SizedBox(width: 5),
              _buildSwitchButton(
                'HOUR',
                !isDay,
                () {
                  _herdChartsInteractor.switchDayHoursTemperature(TimeInterval.hour);
                },
              ),
            ],
          ),
          _buildButtonDate(
            f.format(date),
            date,
            (DateTime date) {
              _herdChartsInteractor.dateChangeTemperature(date);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchDayHoursWater() {
    final date = _herdChartsModelUI?.water?.date ?? DateTime.now();
    final isDay = _herdChartsModelUI?.water?.timeInterval == TimeInterval.day;
    final f = DateFormat('MMM, yyyy');
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildSwitchButton(
                'DAY',
                isDay,
                () {
                  _herdChartsInteractor.switchDayHoursWater(TimeInterval.day);
                },
              ),
              const SizedBox(width: 5),
              _buildSwitchButton(
                'HOUR',
                !isDay,
                () {
                  _herdChartsInteractor.switchDayHoursWater(TimeInterval.hour);
                },
              ),
            ],
          ),
          _buildButtonDate(
            f.format(date),
            date,
            (DateTime date) {
              _herdChartsInteractor.dateChangeWater(date);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchButton(String text, bool isChoose, void Function() onTap) {
    return Container(
      height: _heightButtons,
      width: _wightButtons,
      decoration: DesignStile.buttonDecoration(
        color: isChoose ? DesignStile.grey : DesignStile.white,
        colorBorder: isChoose ? DesignStile.grey : DesignStile.white,
        offset: const Offset(0, 2),
      ),
      child: InkCustomButton(
        height: _heightButtons,
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: DesignStile.textStyleCustom(
              fontSize: 18,
              color: isChoose ? DesignStile.white : DesignStile.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonDate(String text, DateTime date, void Function(DateTime date) onTap) {
    return Container(
      height: _heightButtons,
      width: _wightButton,
      decoration: DesignStile.buttonDecoration(
        color: DesignStile.grey,
        colorBorder: DesignStile.grey,
        offset: const Offset(0, 2),
      ),
      child: InkCustomButton(
        height: _heightButtons,
        onTap: () {
          _showPicker(AppNavigator.context, date, onTap);
        },
        child: Center(
          child: Text(
            text,
            style: DesignStile.textStyleCustom(
              fontSize: 18,
              color: DesignStile.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context, DateTime date, void Function(DateTime date) onTap) {
    final f = DateFormat('MM-yyyy');
    int initialItem = 0;
    final now = DateTime.now();
    final listDate = List.generate(40, (i) {
      final dateIndex = DateTime(
        now.year,
        now.month - i,
        now.day,
      );
      final isSame = f.format(dateIndex) == f.format(date);
      if (isSame) {
        initialItem = i;
      }
      return dateIndex;
    });
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 250,
              decoration: DesignStile.buttonDecoration(),
              child: CupertinoPicker(
                backgroundColor: DesignStile.white.withOpacity(0.8),
                itemExtent: 50,
                scrollController: FixedExtentScrollController(initialItem: initialItem),
                onSelectedItemChanged: (i) {
                  onTap(listDate[i]);
                },
                children: listDate.map((e) => _buildLabelOfMonth(e)).toList(),
              ),
            ));
  }

  Widget _buildLabelOfMonth(DateTime e) {
    final f1 = DateFormat('MMMM');
    final f2 = DateFormat('yyyy');
    return Row(
      children: [
        Expanded(child: Container()),
        Expanded(
          flex: 2,
          child: Text(
            f1.format(e),
            style: DesignStile.textStyleCustom(
              fontSize: 20,
              color: DesignStile.dark,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            f2.format(e),
            style: DesignStile.textStyleCustom(
              fontSize: 20,
              color: DesignStile.dark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchGroupLactationsTemperature() {
    final isLactations = _herdChartsModelUI?.temperature?.subGroup == SubGroupOfCharts.lactations;
    final isDay = _herdChartsModelUI?.temperature?.timeInterval == TimeInterval.day;
    List<Widget> children = [];
    if (isLactations) {
      if (isDay) {
        final g = _herdChartsModelUI?.temperature?.lactations?.lactationsDays;
        children = [
          _buildOffOnButton(g?.bred?.name ?? '', g?.bred?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.bred);
          }, ActionLineOfLactations.bred),
          _buildOffOnButton(g?.dry?.name ?? '', g?.dry?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.dry);
          }, ActionLineOfLactations.dry),
          _buildOffOnButton(g?.fresh?.name ?? '', g?.fresh?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.fresh);
          }, ActionLineOfLactations.fresh),
          _buildOffOnButton(g?.noBred?.name ?? '', g?.noBred?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.noBred);
          }, ActionLineOfLactations.noBred),
          _buildOffOnButton(g?.okOpen?.name ?? '', g?.okOpen?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.okOpen);
          }, ActionLineOfLactations.okOpen),
          _buildOffOnButton(g?.preg?.name ?? '', g?.preg?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.preg);
          }, ActionLineOfLactations.preg),
          _buildOffOnButton(g?.undefined?.name ?? '', g?.undefined?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.undefined);
          }, ActionLineOfLactations.undefined),
          _buildOffOnButton(g?.total?.name ?? '', g?.total?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.total);
          }, ActionLineOfLactations.total),
          _buildOffOnButton(g?.outside?.name ?? '', g?.outside?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.outside);
          }, ActionLineOfLactations.outside),
        ];
      } else {
        final g = _herdChartsModelUI?.temperature?.lactations?.lactationsHours;
        children = [
          _buildOffOnButton(g?.bred?.name ?? '', g?.bred?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.bred);
          }, ActionLineOfLactations.bred),
          _buildOffOnButton(g?.dry?.name ?? '', g?.dry?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.dry);
          }, ActionLineOfLactations.dry),
          _buildOffOnButton(g?.fresh?.name ?? '', g?.fresh?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.fresh);
          }, ActionLineOfLactations.fresh),
          _buildOffOnButton(g?.noBred?.name ?? '', g?.noBred?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.noBred);
          }, ActionLineOfLactations.noBred),
          _buildOffOnButton(g?.okOpen?.name ?? '', g?.okOpen?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.okOpen);
          }, ActionLineOfLactations.okOpen),
          _buildOffOnButton(g?.preg?.name ?? '', g?.preg?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.preg);
          }, ActionLineOfLactations.preg),
          _buildOffOnButton(g?.undefined?.name ?? '', g?.undefined?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.undefined);
          }, ActionLineOfLactations.undefined),
          _buildOffOnButton(g?.total?.name ?? '', g?.total?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.total);
          }, ActionLineOfLactations.total),
          _buildOffOnButton(g?.outside?.name ?? '', g?.outside?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicTemperature(isDay, ActionLineOfLactations.outside);
          }, ActionLineOfLactations.outside),
        ];
      }
    } else {
      if (isDay) {
        final g = _herdChartsModelUI?.temperature?.groups?.groupsDays;
        children = [
          _buildOffOnButton(g?.g1?.name ?? '', g?.g1?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.g1);
          }, ActionLineOfGroups.g1),
          _buildOffOnButton(g?.g2?.name ?? '', g?.g2?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.g2);
          }, ActionLineOfGroups.g2),
          _buildOffOnButton(g?.g3?.name ?? '', g?.g3?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.g3);
          }, ActionLineOfGroups.g3),
          _buildOffOnButton(g?.g4?.name ?? '', g?.g4?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.g4);
          }, ActionLineOfGroups.g4),
          _buildOffOnButton(g?.g5?.name ?? '', g?.g5?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.g5);
          }, ActionLineOfGroups.g5),
          _buildOffOnButton(g?.undefined?.name ?? '', g?.undefined?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.undefined);
          }, ActionLineOfGroups.undefined),
          _buildOffOnButton(g?.total?.name ?? '', g?.total?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.total);
          }, ActionLineOfGroups.total),
          _buildOffOnButton(g?.outside?.name ?? '', g?.outside?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.outside);
          }, ActionLineOfGroups.outside),
        ];
      } else {
        final g = _herdChartsModelUI?.temperature?.groups?.groupsHours;
        children = [
          _buildOffOnButton(g?.g1?.name ?? '', g?.g1?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.g1);
          }, ActionLineOfGroups.g1),
          _buildOffOnButton(g?.g2?.name ?? '', g?.g2?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.g2);
          }, ActionLineOfGroups.g2),
          _buildOffOnButton(g?.g3?.name ?? '', g?.g3?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.g3);
          }, ActionLineOfGroups.g3),
          _buildOffOnButton(g?.g4?.name ?? '', g?.g4?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.g4);
          }, ActionLineOfGroups.g4),
          _buildOffOnButton(g?.g5?.name ?? '', g?.g5?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.g5);
          }, ActionLineOfGroups.g5),
          _buildOffOnButton(g?.undefined?.name ?? '', g?.undefined?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.undefined);
          }, ActionLineOfGroups.undefined),
          _buildOffOnButton(g?.total?.name ?? '', g?.total?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.total);
          }, ActionLineOfGroups.total),
          _buildOffOnButton(g?.outside?.name ?? '', g?.outside?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicTemperature(isDay, ActionLineOfGroups.outside);
          }, ActionLineOfGroups.outside),
        ];
      }
    }
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
      color: DesignStile.disable,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSwitchBottomButton(
                'LACTATIONS',
                isLactations,
                () {
                  _herdChartsInteractor.switchGroupLactationsTemperature(SubGroupOfCharts.lactations);
                },
              ),
              const SizedBox(width: 5),
              _buildSwitchBottomButton(
                'GROUPS',
                !isLactations,
                () {
                  _herdChartsInteractor.switchGroupLactationsTemperature(SubGroupOfCharts.groups);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: DesignStile.buttonDecoration(
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
            child: Wrap(
              runAlignment: WrapAlignment.spaceEvenly,
              alignment: WrapAlignment.spaceEvenly,
              spacing: 5,
              runSpacing: 10,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchGroupLactationsWater() {
    final isLactations = _herdChartsModelUI?.water?.subGroup == SubGroupOfCharts.lactations;
    final isDay = _herdChartsModelUI?.water?.timeInterval == TimeInterval.day;
    List<Widget> children = [];
    if (isLactations) {
      if (isDay) {
        final g = _herdChartsModelUI?.water?.lactations?.lactationsDays;
        children = [
          _buildOffOnButton(g?.bred?.name ?? '', g?.bred?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.bred);
          }, ActionLineOfLactations.bred),
          _buildOffOnButton(g?.dry?.name ?? '', g?.dry?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.dry);
          }, ActionLineOfLactations.dry),
          _buildOffOnButton(g?.fresh?.name ?? '', g?.fresh?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.fresh);
          }, ActionLineOfLactations.fresh),
          _buildOffOnButton(g?.noBred?.name ?? '', g?.noBred?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.noBred);
          }, ActionLineOfLactations.noBred),
          _buildOffOnButton(g?.okOpen?.name ?? '', g?.okOpen?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.okOpen);
          }, ActionLineOfLactations.okOpen),
          _buildOffOnButton(g?.preg?.name ?? '', g?.preg?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.preg);
          }, ActionLineOfLactations.preg),
          _buildOffOnButton(g?.undefined?.name ?? '', g?.undefined?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.undefined);
          }, ActionLineOfLactations.undefined),
          _buildOffOnButton(g?.total?.name ?? '', g?.total?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.total);
          }, ActionLineOfLactations.total),
          _buildOffOnButton(g?.outside?.name ?? '', g?.outside?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.outside);
          }, ActionLineOfLactations.outside),
        ];
      } else {
        final g = _herdChartsModelUI?.water?.lactations?.lactationsHours;
        children = [
          _buildOffOnButton(g?.bred?.name ?? '', g?.bred?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.bred);
          }, ActionLineOfLactations.bred),
          _buildOffOnButton(g?.dry?.name ?? '', g?.dry?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.dry);
          }, ActionLineOfLactations.dry),
          _buildOffOnButton(g?.fresh?.name ?? '', g?.fresh?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.fresh);
          }, ActionLineOfLactations.fresh),
          _buildOffOnButton(g?.noBred?.name ?? '', g?.noBred?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.noBred);
          }, ActionLineOfLactations.noBred),
          _buildOffOnButton(g?.okOpen?.name ?? '', g?.okOpen?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.okOpen);
          }, ActionLineOfLactations.okOpen),
          _buildOffOnButton(g?.preg?.name ?? '', g?.preg?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.preg);
          }, ActionLineOfLactations.preg),
          _buildOffOnButton(g?.undefined?.name ?? '', g?.undefined?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.undefined);
          }, ActionLineOfLactations.undefined),
          _buildOffOnButton(g?.total?.name ?? '', g?.total?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.total);
          }, ActionLineOfLactations.total),
          _buildOffOnButton(g?.outside?.name ?? '', g?.outside?.isShow ?? false, () {
            _herdChartsInteractor.offOnLactationsGraphicWater(isDay, ActionLineOfLactations.outside);
          }, ActionLineOfLactations.outside),
        ];
      }
    } else {
      if (isDay) {
        final g = _herdChartsModelUI?.water?.groups?.groupsDays;
        children = [
          _buildOffOnButton(g?.g1?.name ?? '', g?.g1?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.g1);
          }, ActionLineOfGroups.g1),
          _buildOffOnButton(g?.g2?.name ?? '', g?.g2?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.g2);
          }, ActionLineOfGroups.g2),
          _buildOffOnButton(g?.g3?.name ?? '', g?.g3?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.g3);
          }, ActionLineOfGroups.g3),
          _buildOffOnButton(g?.g4?.name ?? '', g?.g4?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.g4);
          }, ActionLineOfGroups.g4),
          _buildOffOnButton(g?.g5?.name ?? '', g?.g5?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.g5);
          }, ActionLineOfGroups.g5),
          _buildOffOnButton(g?.undefined?.name ?? '', g?.undefined?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.undefined);
          }, ActionLineOfGroups.undefined),
          _buildOffOnButton(g?.total?.name ?? '', g?.total?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.total);
          }, ActionLineOfGroups.total),
          _buildOffOnButton(g?.outside?.name ?? '', g?.outside?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.outside);
          }, ActionLineOfGroups.outside),
        ];
      } else {
        final g = _herdChartsModelUI?.water?.groups?.groupsHours;
        children = [
          _buildOffOnButton(g?.g1?.name ?? '', g?.g1?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.g1);
          }, ActionLineOfGroups.g1),
          _buildOffOnButton(g?.g2?.name ?? '', g?.g2?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.g2);
          }, ActionLineOfGroups.g2),
          _buildOffOnButton(g?.g3?.name ?? '', g?.g3?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.g3);
          }, ActionLineOfGroups.g3),
          _buildOffOnButton(g?.g4?.name ?? '', g?.g4?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.g4);
          }, ActionLineOfGroups.g4),
          _buildOffOnButton(g?.g5?.name ?? '', g?.g5?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.g5);
          }, ActionLineOfGroups.g5),
          _buildOffOnButton(g?.undefined?.name ?? '', g?.undefined?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.undefined);
          }, ActionLineOfGroups.undefined),
          _buildOffOnButton(g?.total?.name ?? '', g?.total?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.total);
          }, ActionLineOfGroups.total),
          _buildOffOnButton(g?.outside?.name ?? '', g?.outside?.isShow ?? false, () {
            _herdChartsInteractor.offOnGroupsGraphicWater(isDay, ActionLineOfGroups.outside);
          }, ActionLineOfGroups.outside),
        ];
      }
    }
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
      color: DesignStile.disable,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSwitchBottomButton(
                'LACTATIONS',
                isLactations,
                () {
                  _herdChartsInteractor.switchGroupLactationsWater(SubGroupOfCharts.lactations);
                },
              ),
              const SizedBox(width: 5),
              _buildSwitchBottomButton(
                'GROUPS',
                !isLactations,
                () {
                  _herdChartsInteractor.switchGroupLactationsWater(SubGroupOfCharts.groups);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: DesignStile.buttonDecoration(
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
            child: Wrap(
              runAlignment: WrapAlignment.spaceEvenly,
              alignment: WrapAlignment.spaceEvenly,
              spacing: 5,
              runSpacing: 10,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchBottomButton(String text, bool isChoose, void Function() onTap) {
    return Container(
      height: _heightButtons,
      width: _wightBottomButtons,
      decoration: DesignStile.buttonDecoration(
        color: isChoose ? DesignStile.grey : DesignStile.white,
        colorBorder: isChoose ? DesignStile.grey : DesignStile.white,
        offset: const Offset(0, 2),
      ),
      child: InkCustomButton(
        height: _heightButtons,
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: DesignStile.textStyleCustom(
              fontSize: 18,
              color: isChoose ? DesignStile.white : DesignStile.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOffOnButton(String text, bool isChoose, void Function() onTap, dynamic en) {
    final color = ColorsCollection.color(en);
    return Container(
      height: 25,
      width: 90,
      decoration: DesignStile.buttonDecoration(
        borderRadius: 20,
        color: isChoose ? DesignStile.grey : DesignStile.white,
        colorBorder: color,
        offset: const Offset(0, 2),
      ),
      child: InkCustomButton(
        borderRadius: BorderRadius.circular(20),
        height: _heightButtons,
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: DesignStile.textStyleCustom(
              color: isChoose ? DesignStile.white : DesignStile.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: DesignStile.buttonDecoration(
        borderRadius: 0,
        blurRadius: 10,
        offset: const Offset(0, 1),
        colorBoxShadow: DesignStile.red,
      ),
      child: const Divider(
        color: DesignStile.white,
        height: 5,
        thickness: 4,
      ),
    );
  }

  static const double _heightButtons = 35;
  static const double _wightButtons = 80;
  static const double _wightBottomButtons = 150;
  static const double _wightButton = 120;
}
