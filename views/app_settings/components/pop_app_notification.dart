import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/components/buttons/toggle_double_button.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../app_settings_interactor.dart';
import '../models/app_settings_model_ui.dart';

class PopAppNotification extends StatefulWidget {
  final AppSettingModelUI appSettingModelUI;
  final AppSettingInteractor appSettingInteractor;

  const PopAppNotification({
    Key key,
    @required this.appSettingModelUI,
    @required this.appSettingInteractor,
  }) : super(key: key);

  @override
  _PopAppNotificationState createState() => _PopAppNotificationState();
}

class _PopAppNotificationState extends State<PopAppNotification> {
  AppSettingModelUI _appSettingModelUI;
  final _f = DateFormat.j(); //"6 AM"
  String from;
  String to;
  String _from;
  String _to;
  @override
  void initState() {
    _appSettingModelUI = widget.appSettingModelUI;
    from = _appSettingModelUI?.notificationPeriod?.from;
    to = _appSettingModelUI?.notificationPeriod?.to;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppSettingModelUI>(
      stream: widget?.appSettingInteractor?.observer,
      builder: (context, snapshot) {
        _appSettingModelUI = snapshot?.data ?? _appSettingModelUI;
        return _buildSettingsPart(
          440,
          'Notification Preferences',
          _buildNotificationControl(),
        );
      },
    );
  }

  Widget _buildSettingsPart(double height, String string, List<Widget> settingsControl) {
    final heightFull = MediaQuery.of(context).size.height;

    final Widget child = Scaffold(
      backgroundColor: Colors.transparent,
      body: Hero(
        tag: string,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          margin:
              EdgeInsets.only(left: 10, right: 10, top: (heightFull - height) / 2, bottom: (heightFull - height) / 2),
          decoration: DesignStile.buttonDecoration(
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
          child: Column(
            children: [
              Text(
                string,
                style: DesignStile.textStyleCustom(
                  color: DesignStile.dark,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              ...settingsControl,
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  _buildButtonSaveSettings(false, 'Close'),
                  _buildButtonSaveSettings(true, 'Save'),
                ]),
              ),
            ],
          ),
        ),
      ),
    );

    return Hero(
      tag: string,
      child: Container(
        height: 50,
        width: double.maxFinite,
        margin: const EdgeInsets.only(left: 15, right: 15, top: 30),
        decoration: DesignStile.buttonDecoration(
          blurRadius: 10,
          offset: const Offset(0, 1),
        ),
        child: InkCustomButton(
          onTap: () {
            AppNavigator.dialog(child);
          },
          child: Center(
            child: Text(
              string,
              style: DesignStile.textStyleCustom(
                color: DesignStile.dark,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNotificationControl() {
    _formatInterval();

    return [
      _buildTitleOfControlsPart('Receive notifications between:'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButtonInterval(
            () async {
              final TimeRange time = await _pickedTime(
                context,
                TimeOfDay(hour: int.tryParse(from) ?? 0, minute: 0),
                TimeOfDay(hour: int.tryParse(to) ?? 0, minute: 0),
              );
              if (time != null) {
                final hourStart = time.startTime.hour;
                final hourEnd = time.endTime.hour;

                widget.appSettingInteractor.saveNotification('setNotificationPeriod/FROM/$hourStart');
                widget.appSettingInteractor.saveNotification('setNotificationPeriod/TO/$hourEnd', true, false);
                setState(() {
                  from = '$hourStart';
                  to = '$hourEnd';
                });
              }
            },
          ),
        ],
      ),
      const Divider(thickness: 2),
      Row(
        children: [
          Expanded(child: _buildTitleOfControlsNotification('Alert')),
          Expanded(child: _buildTitleOfControlsNotification('Email')),
          Expanded(child: _buildTitleOfControlsNotification('SMS')),
          Expanded(child: _buildTitleOfControlsNotification('Push')),
        ],
      ),
      const SizedBox(height: 10),
      _buildEventPreferences(_appSettingModelUI?.notificationPreferences?.firstWhere((e) => e.id == 1)),
      const SizedBox(height: 5),
      _buildEventPreferences(_appSettingModelUI?.notificationPreferences?.firstWhere((e) => e.id == 2)),
      const SizedBox(height: 5),
      _buildEventPreferences(_appSettingModelUI?.notificationPreferences?.firstWhere((e) => e.id == 3)),
      const SizedBox(height: 5),
      _buildEventPreferences(_appSettingModelUI?.notificationPreferences?.firstWhere((e) => e.id == 4)),
    ];
  }

  void _formatInterval() {
    if (from?.isNotEmpty ?? false) {
      final t = TimeOfDay(hour: int.tryParse(from) ?? 0, minute: 0);
      _from = formatTimeOfDay(t, _f);
    } else {
      _from = '--';
    }
    if (to?.isNotEmpty ?? false) {
      final t = TimeOfDay(hour: int.tryParse(to) ?? 0, minute: 0);
      _to = formatTimeOfDay(t, _f);
    } else {
      _to = '--';
    }
  }

  Widget _buildTitleOfControlsNotification(String string) {
    return Center(
      child: Text(
        string,
        style: DesignStile.textStyleCustom(
          color: DesignStile.grey,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildTitleOfControlsPart(String string) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          string,
          style: DesignStile.textStyleCustom(
            color: DesignStile.grey,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonInterval(
    void Function() onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkCustomButton(
        height: 40,
        width: 200,
        onTap: onTap,
        child: Container(
          width: 80,
          alignment: const Alignment(0, 0),
          decoration: DesignStile.buttonDecoration(offset: const Offset(0, 1)),
          child: StreamBuilder<AppSettingModelUI>(
              stream: widget.appSettingInteractor.observer,
              builder: (context, snapshot) {
                from = snapshot?.data?.notificationPeriod?.from ?? from;
                to = snapshot?.data?.notificationPeriod?.to ?? to;
                _formatInterval();
                print('$_from and $_to');
                return Text(
                  '$_from and $_to',
                  style: DesignStile.textStyleCustom(fontSize: 20, color: DesignStile.dark),
                );
              }),
        ),
      ),
    );
  }

  Widget _buildEventPreferences(NotificationPreferencesModelUI notification) {
    return Container(
      color: DesignStile.transparent,
      padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                notification?.nameEvent ?? '',
                style: DesignStile.textStyleCustom(
                  fontWeight: FontWeight.w900,
                  color: DesignStile.dark,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: CustomDoubleToggle(
                isEnable: notification?.isActiveEmail ?? false,
                sizeToggle: sizeToggle,
                callbackAction: (_) {
                  final parameters = '${notification?.setKeyEvent}/EMAIL_ON/$_';
                  widget.appSettingInteractor.saveNotification(parameters);
                },
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: CustomDoubleToggle(
                isEnable: notification?.isActiveSMS ?? false,
                sizeToggle: sizeToggle,
                callbackAction: (_) {
                  final parameters = '${notification?.setKeyEvent}/SMS_ON/$_';
                  widget.appSettingInteractor.saveNotification(parameters);
                },
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: CustomDoubleToggle(
                isEnable: notification?.isActivePush ?? false,
                sizeToggle: sizeToggle,
                callbackAction: (_) {
                  final parameters = '${notification?.setKeyEvent}/PUSH_ON/$_';
                  widget.appSettingInteractor.saveNotification(parameters);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSaveSettings(bool isSave, String string, [Function function]) {
    return Expanded(
      child: StreamBuilder<AppSettingModelUI>(
          stream: widget.appSettingInteractor?.observer,
          builder: (context, snapshot) {
            _appSettingModelUI = snapshot?.data ?? _appSettingModelUI;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: InkCustomButton(
                height: 50,
                onTap: () {
                  AppNavigator.pop();

                  if (function != null) {
                    function();
                  }
                },
                child: Container(
                  alignment: const Alignment(0, 0),
                  decoration: DesignStile.buttonDecoration(
                    blurRadius: 10,
                    borderRadius: 10,
                    offset: const Offset(0, 2),
                    colorBoxShadow: isSave ? DesignStile.red : DesignStile.grey,
                    color: isSave ? DesignStile.primary : DesignStile.grey,
                  ),
                  child: Text(
                    string,
                    style: DesignStile.textStyleCustom(
                      fontSize: 24,
                      color: DesignStile.white,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future<TimeRange> _pickedTime(BuildContext context, TimeOfDay start, TimeOfDay end) async {
    final labels = List.generate(8, (i) {
      final time = TimeOfDay(hour: i * 3, minute: 0);
      return ClockLabel.fromTime(time: time, text: formatTimeOfDay(time, _f));
    });
    return await showTimeRangePicker(
      context: context,
      start: start,
      end: end,
      labels: labels,
      labelOffset: -30,
      rotateLabels: false,
      use24HourFormat: false,
      interval: const Duration(hours: 1),
    ) as TimeRange;
  }

  String formatTimeOfDay(TimeOfDay tod, DateFormat format) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return format.format(dt);
  }

  static Size sizeToggle = const Size(60, 30);
}
