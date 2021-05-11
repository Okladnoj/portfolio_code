import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/components/dialog/notify_dialog.dart';
import 'package:cattle_scan/components/formers/screen_former.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/alerts/alerts_interactor.dart';
import 'package:cattle_scan/views/alerts/models/alert_model_ui.dart';
import 'package:cattle_scan/views/alerts/widgets/title.dart';
import 'package:cattle_scan/views/cows_list/models/cow_model.dart';
import 'package:cattle_scan/views/event_by_cow/cow_event_interactor.dart';
import 'package:flutter/material.dart';

import 'create_feedback_interactor.dart';
import 'widgets/check_form.dart';

class CreateFeedback extends StatefulWidget {
  final AlertModelUI alert;
  final int countBackSteps;
  final AlertsInteractor alertsInteractor;
  final EventsInteractor eventsInteractor;

  const CreateFeedback({
    Key key,
    @required this.alert,
    @required this.countBackSteps,
    @required this.alertsInteractor,
    this.eventsInteractor,
  }) : super(key: key);
  @override
  _CreateFeedbackState createState() => _CreateFeedbackState();
}

class _CreateFeedbackState extends State<CreateFeedback> with WidgetsBindingObserver {
  AlertModelUI _alert;
  FeedbackModelUI _feedBackModelUI;
  AlertsOfFeedbackInteractor _alertsInteractor;

  final _scrollController = ScrollController();

  bool get isChoose => _feedBackModelUI?.isChoose ?? false;

  @override
  void initState() {
    super.initState();
    _alert = widget.alert;
    _alertsInteractor = AlertsOfFeedbackInteractor()..setAlertId(_alert.id);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    print('value $value');
    _alertsInteractor.simpleUpdate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFormer(
      controller: _scrollController,
      titleActions: TitleAlerts(nameTitle: 'Provide Feedback', subBackFunction: () => _actionWithDialog()),
      bottomButton: _buildButtonsCreateFeedBack(),
      children: [
        _buildDescribe(),
        _buildSettingsControl(),
        const SizedBox(height: 200),
      ],
    );
  }

  Widget _buildDescribe() {
    return Column(
      children: [
        Container(
          alignment: const Alignment(0, 0),
          height: 80,
          child: Text(
            'Cow ${_alert.cowId}',
            style: DesignStile.textStyleCustom(
              color: DesignStile.black,
              fontSize: 25,
            ),
          ),
        ),
        Container(
          alignment: const Alignment(0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            _alert.message,
            style: DesignStile.textStyleCustom(
              color: DesignStile.black,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsControl() {
    return StreamBuilder<FeedbackModelUI>(
        stream: _alertsInteractor.observerFeedbackOfAlert,
        builder: (context, snapshot) {
          _feedBackModelUI = snapshot.data ?? _feedBackModelUI;
          return Column(
            children: [
              CheckForm(
                title: 'Visual symptoms',
                isOpen: _feedBackModelUI?.visualSymptoms ?? false,
                callBack: (_) {
                  _alertsInteractor.setVisualSymptoms(_);
                },
              ),
              _buildRectalTemperature(),
              CheckForm(
                title: 'Milk dropped',
                isOpen: _feedBackModelUI?.milkDropped ?? false,
                callBack: (_) {
                  _alertsInteractor.setMilkDropped(_);
                },
              ),
              CheckForm(
                title: 'Put to sort',
                isOpen: _feedBackModelUI?.putToSort ?? false,
                callBack: (_) {
                  _alertsInteractor.setPutToSort(_);
                },
              ),
              _buildGeneralNote(),
              _buildGoToCreateEvent(),
              SizedBox(height: MediaQuery.of(context).size.height / 3)
            ],
          );
        });
  }

  final _textControllerRectalTemperature = TextEditingController();
  final _formKey2 = GlobalKey<FormState>();
  Widget _buildRectalTemperature() {
    final bool isShowField = (_feedBackModelUI?.rectalTemperature ?? -1.0) != -1.0;
    String text;
    if ((_feedBackModelUI?.rectalTemperature ?? 0) > 0) {
      text = _feedBackModelUI?.rectalTemperature?.toString() ?? '';
    } else {
      text = '';
    }

    _textControllerRectalTemperature.text = text;

    return CheckForm(
      title: 'Rectal temperature',
      isOpen: isShowField,
      callBack: (_) {
        double rectalTemperature;

        try {
          rectalTemperature = double.tryParse(_textControllerRectalTemperature.text);
        } catch (e) {
          rectalTemperature = _ ? 0 : -1;
        }
        if (_) {
          rectalTemperature = 0;
          _alertsInteractor.setRectalTemperature(rectalTemperature);
        } else {
          _alertsInteractor.dellRectalTemperature();
        }
      },
      child: isShowField
          ? Column(
              children: [
                TextFormField(
                  key: _formKey2,
                  controller: _textControllerRectalTemperature,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '0.0',
                    labelText: 'Enter temperature (°C)',
                  ),
                  onChanged: (value) {
                    double rectalTemperature;

                    try {
                      rectalTemperature = double.tryParse(value);
                    } catch (e) {
                      rectalTemperature = -1;
                    }
                    _alertsInteractor.setRectalTemperature(rectalTemperature, false);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            alignment: const Alignment(0, 0),
                            height: 30,
                            child: Text(
                              _feedBackModelUI?.rectalTemperatureTime ?? 'Date is not selected',
                              style: DesignStile.textStyleCustom(
                                fontSize: 16,
                                color: DesignStile.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: InkCustomButton(
                          onTap: () async {
                            //
                            final data = await _pickedDateTime(context);
                            final time = await _pickedTime(context);
                            _alertsInteractor.setRectalTemperatureMeasuringTime(DateTime(
                              data.year,
                              data.month,
                              data.day,
                              time.hour,
                              time.minute,
                            ));
                          },
                          child: Container(
                            alignment: const Alignment(0, 0),
                            width: 50,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: DesignStile.buttonDecoration(
                              colorBorder: DesignStile.primary,
                              color: DesignStile.primary,
                            ),
                            child: const Icon(
                              Icons.today_rounded,
                              size: 40,
                              color: DesignStile.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          : Container(),
    );
  }

  Future<TimeOfDay> _pickedTime(BuildContext context) => showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
      );
  Future<DateTime> _pickedDateTime(BuildContext context) => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
      );
  final _textControllerGeneralNote = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  Widget _buildGeneralNote() {
    final bool isShowField = _feedBackModelUI?.generalNote != null ?? false;
    _textControllerGeneralNote.text = _feedBackModelUI?.generalNote ?? '';
    final GlobalKey key = GlobalKey();

    return CheckForm(
      key: key,
      title: 'General note',
      isOpen: isShowField,
      callBack: (_) {
        if (_) {
          _alertsInteractor.setGeneralNote(_textControllerGeneralNote.text);
          _scrollCorrection(key);
        } else {
          _alertsInteractor.dellGeneralNote();
        }
      },
      child: isShowField
          ? TextFormField(
              key: _formKey1,
              controller: _textControllerGeneralNote,
              autofocus: true,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              maxLines: 3,
              onChanged: (value) {
                _alertsInteractor.setGeneralNote(_textControllerGeneralNote.text, false);
              },
            )
          : Container(),
    );
  }

  void _scrollCorrection(GlobalKey<State<StatefulWidget>> key) {
    final box = key.currentContext.findRenderObject() as RenderBox;
    final dy = box.localToGlobal(Offset.zero).dy;
    final offset = _scrollController.offset;
    final scrollCorrect = offset + dy - 40;
    // _scrollController.position.correctBy(scrollCorrect);
    _scrollController.animateTo(scrollCorrect, duration: const Duration(milliseconds: 800), curve: Curves.ease);
  }

  Widget _buildGoToCreateEvent() {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(
        top: 15,
        right: 15,
        left: 15,
      ),
      child: InkCustomButton(
        onTap: () async {
          _alertsInteractor.setIsImportant(true);
          _alertsInteractor.upLoadFeedback();
          final cow = Cow(
            animalId: _alert.cowId,
            bolusId: _alert.bolusId,
          );
          AppNavigator.navigateToCreateEvent(
            Future.value([cow]),
            (widget?.countBackSteps ?? 0) + 1,
            _alert,
            widget.alertsInteractor,
            widget.eventsInteractor,
          );
        },
        child: Container(
          alignment: const Alignment(0, 0),
          decoration: DesignStile.buttonDecoration(
            color: DesignStile.dark,
            colorBorder: DesignStile.dark,
          ),
          child: Text(
            'Create Event',
            style: DesignStile.textStyleCustom(
              color: DesignStile.white,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonsCreateFeedBack() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 30,
        right: 15,
        left: 15,
      ),
      child: Row(
        children: [
          _buildButton('Cancel', () async {
            await _actionWithDialog();
            _popAction();
          }, 2),
          const SizedBox(width: 15),
          _buildButton('Save Feedback', () async {
            _alertsInteractor?.setIsImportant(true);
            _popAction();
            await _alertsInteractor?.upLoadFeedback();
            await widget?.alertsInteractor?.simpleUpdate();
          }, 3, false),
        ],
      ),
    );
  }

  Future _actionWithDialog() async {
    final result = await AppNavigator.dialog<bool>(
      const NotifyDialog(
        title: 'Was this Alert useful?',
        describe: 'Please select one of the answer options, if you do not want to answer, click outside this dialog',
        labelFirstButton: 'No',
        labelSecondButton: 'Yes',
        isReorder: true,
      ),
    );
    _alertsInteractor.setIsImportant(result);
    print(result);
  }

  void _popAction() {
    for (var i = 0; i < widget.countBackSteps; i++) {
      AppNavigator.pop();
    }
  }

  Widget _buildButton(
    String nameButton,
    void Function() onTap,
    int flex, [
    bool enable = true,
  ]) {
    return Expanded(
      flex: flex,
      child: SizedBox(
        height: 60,
        child: StreamBuilder<FeedbackModelUI>(
            stream: _alertsInteractor.observerFeedbackOfAlert,
            builder: (context, snapshot) {
              _feedBackModelUI = snapshot.data ?? _feedBackModelUI;
              return InkCustomButton(
                onTap: enable || isChoose ? onTap : null,
                child: Container(
                  alignment: const Alignment(0, 0),
                  decoration: DesignStile.buttonDecoration(
                    color: enable || isChoose ? DesignStile.primary : DesignStile.grey,
                    colorBorder: enable || isChoose ? DesignStile.primary : DesignStile.grey,
                  ),
                  child: Text(
                    nameButton,
                    style: DesignStile.textStyleCustom(
                      color: DesignStile.white,
                      fontSize: 22,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
