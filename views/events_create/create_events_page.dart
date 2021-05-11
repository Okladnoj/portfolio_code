import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/components/formers/screen_former.dart';
import 'package:cattle_scan/components/pikers/custom_dropdown.dart';
import 'package:cattle_scan/components/pikers/modal_piker.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/alerts/alerts_interactor.dart';
import 'package:cattle_scan/views/alerts/models/alert_model_ui.dart';
import 'package:cattle_scan/views/alerts/widgets/title.dart';
import 'package:cattle_scan/views/event_by_cow/cow_event_interactor.dart';
import 'package:cattle_scan/views/cows_list/models/cow_model.dart';
import 'package:cattle_scan/views/feedback_create/widgets/check_form.dart';
import 'package:flutter/material.dart';

import 'create_events_interactor.dart';
import 'models/diagnose_model.dart';

class CreateEvent extends StatefulWidget {
  final Future<List<Cow>> listCow;
  final AlertsInteractor alertsInteractor;
  final int countBackSteps;
  final AlertModelUI alert;
  final EventsInteractor eventsInteractor;
  final DiagnoseModel currentDiagnose;

  const CreateEvent({
    Key key,
    @required this.listCow,
    @required this.countBackSteps,
    this.alert,
    @required this.alertsInteractor,
    this.eventsInteractor,
    this.currentDiagnose,
  }) : super(key: key);
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  Future<List<Cow>> _listCowFuture;
  List<Cow> _listCow;
  Cow _currentCow;
  DiagnoseModel _currentDiagnose;
  EventModelUI _eventModelUI;
  DiagnoseModels _diagnoseModels;
  CreateEventsInteractor _alertsInteractor;
  bool get isChoose => _eventModelUI?.isChoose ?? false;

  final _scrollController = ScrollController();

  @override
  void initState() {
    _currentDiagnose = widget.currentDiagnose;
    _listCowFuture = widget?.listCow?.then((value) {
      //_currentCow = value?.first;
      _alertsInteractor
        ..setAnimalId(value?.first?.animalId)
        ..setAlertId(widget?.alert?.id);
      return value;
    });
    _alertsInteractor = CreateEventsInteractor();

    super.initState();
  }

  @override
  void dispose() {
    _alertsInteractor.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFormer(
      controller: _scrollController,
      titleActions: const TitleAlerts(nameTitle: 'Create Event'),
      bottomButton: _buildButtonsCreateFeedBack(),
      children: [
        _buildHead(),
        _buildSettingsControl(),
        const SizedBox(height: 200),
      ],
    );
  }

  Widget _buildHead() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        _buildDropdownCow(),
        Container(
          height: 25,
          alignment: const Alignment(0, 1),
          //child: Text('Selected Event', style: DesignStile.textStyleCustom(color: DesignStile.dark, fontSize: 22)),
        ),
        _buildDiagnose(),
      ],
    );
  }

  Widget _buildSettingsControl() {
    return StreamBuilder<EventModelUI>(
        stream: _alertsInteractor.observerEventOfAlert,
        builder: (context, snapshot) {
          _eventModelUI = snapshot.data ?? _eventModelUI;
          return Column(
            children: [
              _buildRectalTemperature(),
              _buildRemark(),
              _buildProtocol(),
              SizedBox(height: MediaQuery.of(context).size.height / 3)
            ],
          );
        });
  }

  Widget _buildDropdownCow() {
    return FutureBuilder<List<Cow>>(
        future: _listCowFuture,
        builder: (context, snapshot) {
          _listCow = snapshot?.data ?? _listCow;
          if ((_listCow?.isNotEmpty ?? false) && _listCow.length < 2) {
            final id = _listCow.first.animalId;
            return Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: DesignStile.transparent,
                      ),
                    ),
                  ),
                  height: 80,
                  alignment: const Alignment(0, 0.7),
                  child: Text('Cow ID: ${id * DesignStile.maskCode}',
                      style: DesignStile.textStyleCustom(color: DesignStile.dark, fontSize: 25)),
                ),
              ],
            );
          }
          final List<PikModel<Cow>> itemsList = List.generate(_listCow?.length ?? 0, (i) {
            final cow = _listCow[i];
            return PikModel(i, cow.name, cow,
                chooseElement: Center(
                  child: Text(
                    'Cow ID: ${cow.animalId * DesignStile.maskCode}',
                    style: DesignStile.textStyleCustom(color: DesignStile.black, fontSize: 22),
                  ),
                ),
                listElement: DropdownMenuItem<Cow>(
                  value: cow,
                  child: Container(
                    color: cow == _currentCow ? DesignStile.transparent : DesignStile.white,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: _paddingDropdown),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cow ${cow.animalId * DesignStile.maskCode}'),
                        // Text('bolusId: ${cow.bolusId * DesignStile.maskCode}'),
                      ],
                    ),
                  ),
                ));
          });
          PikModel<Cow> initialValue;
          try {
            initialValue = itemsList?.firstWhere((e) => e?.value == _currentCow);
          } catch (e) {}
          return Column(
            children: [
              Container(
                height: 40,
                alignment: const Alignment(0, 1),
                // child: Text('Selected Cow', style: DesignStile.textStyleCustom(color: DesignStile.dark, fontSize: 22)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: CustomDropDown<Cow>(
                  initialValue: initialValue,
                  itemsList: itemsList,
                  hightMax: MediaQuery.of(context).size.height / 2,
                  hint: Center(
                      child: Text(
                    'Select Cow',
                    style: DesignStile.textStyleCustom(color: DesignStile.grey, fontSize: 22),
                  )),
                  onChanged: (PikModel<Cow> value) {
                    setState(() {
                      _alertsInteractor.setAnimalId(value?.value?.animalId);
                      _currentCow = value?.value;
                    });
                  },
                ),
              ),
            ],
          );
        });
  }

  Widget _buildDiagnose() {
    return StreamBuilder<DiagnoseModels>(
        stream: _alertsInteractor.observerDiagnoses,
        builder: (context, snapshot) {
          _diagnoseModels = snapshot?.data ?? _diagnoseModels;
          if (_diagnoseModels?.listDiagnoseModel?.isNotEmpty ?? false) {
            // _currentDiagnose = _currentDiagnose ?? _diagnoseModels.listDiagnoseModel.first;
          }
          final List<DiagnoseModel> listDiagnoseModel = _diagnoseModels?.listDiagnoseModel;
          final List<PikModel<DiagnoseModel>> itemsList = List.generate(listDiagnoseModel?.length ?? 0, (i) {
            final diagnoseModel = listDiagnoseModel[i];
            return PikModel(
              i,
              diagnoseModel.name,
              diagnoseModel,
              chooseElement: Center(
                child: Text(
                  diagnoseModel?.name ?? '',
                  style: DesignStile.textStyleCustom(color: DesignStile.black, fontSize: 22),
                ),
              ),
              listElement: DropdownMenuItem<DiagnoseModel>(
                value: diagnoseModel,
                child: Container(
                  color: diagnoseModel == _currentDiagnose ? DesignStile.transparent : DesignStile.white,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: _paddingDropdown),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(diagnoseModel?.name ?? ''),
                      // Text(value.code),
                    ],
                  ),
                ),
              ),
            );
          });
          PikModel<DiagnoseModel> initialValue;
          try {
            initialValue = itemsList?.firstWhere((e) => e?.value == _currentDiagnose);
          } catch (e) {}
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: CustomDropDown<DiagnoseModel>(
              key: Key('${initialValue?.id}'),
              initialValue: initialValue,
              itemsList: itemsList,
              hightMax: MediaQuery.of(context).size.height / 2,
              hint: Center(
                  child: Text(
                'Select Event',
                style: DesignStile.textStyleCustom(color: DesignStile.grey, fontSize: 22),
              )),
              onChanged: (value) {
                setState(() {
                  _alertsInteractor.setEventType(value?.value?.code);
                  _currentDiagnose = value?.value;
                });
              },
            ),
          );
        });
  }

  Widget _buildRectalTemperature() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: const Alignment(0, 0),
                height: 30,
                child: Text(
                  _eventModelUI?.date ?? 'Date is not selected',
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
                final data = await pickedDateTime(context);
                _alertsInteractor.setData(DateTime(
                  data.year,
                  data.month,
                  data.day,
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
    );
  }

  Future<DateTime> pickedDateTime(BuildContext context) => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
      );

  final _textControllerRemark = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  Widget _buildRemark() {
    final bool isShowField = _eventModelUI?.remark != null ?? false;
    _textControllerRemark.text = _eventModelUI?.remark ?? '';
    final GlobalKey key = GlobalKey();

    return CheckForm(
      key: key,
      title: 'Remark',
      isOpen: isShowField,
      callBack: (_) {
        if (_) {
          _alertsInteractor.setRemark(_textControllerRemark.text);
          _scrollCorrection(key);
        } else {
          _alertsInteractor.dellRemark();
        }
      },
      child: isShowField
          ? TextFormField(
              key: _formKey1,
              controller: _textControllerRemark,
              autofocus: true,
              maxLength: 10,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onChanged: (value) {
                _alertsInteractor.setRemark(_textControllerRemark.text, false);
              },
            )
          : Container(),
    );
  }

  final _textControllerProtocol = TextEditingController();
  final _formKey2 = GlobalKey<FormState>();
  Widget _buildProtocol() {
    final bool isShowField = _eventModelUI?.protocols != null ?? false;
    _textControllerProtocol.text = _eventModelUI?.protocols ?? '';
    final GlobalKey key = GlobalKey();

    return CheckForm(
      key: key,
      title: 'Protocol',
      isOpen: isShowField,
      callBack: (_) {
        if (_) {
          _alertsInteractor.setProtocol(_textControllerProtocol.text);
          _scrollCorrection(key);
        } else {
          _alertsInteractor.dellProtocol();
        }
      },
      child: isShowField
          ? TextFormField(
              key: _formKey2,
              controller: _textControllerProtocol,
              autofocus: true,
              maxLength: 10,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onChanged: (value) {
                _alertsInteractor.setProtocol(_textControllerProtocol.text, false);
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
    _scrollController.animateTo(scrollCorrect, duration: const Duration(milliseconds: 800), curve: Curves.ease);
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
          _buildButton('Save Event', () async {
            _pop();
            await _alertsInteractor?.upLoadEvent();
            if (widget.alertsInteractor != null) {
              widget?.alertsInteractor?.simpleUpdate();
              widget?.eventsInteractor?.simpleUpdate();
            }
          }, 1),
        ],
      ),
    );
  }

  void _pop() {
    for (var i = 0; i < widget.countBackSteps; i++) {
      AppNavigator.pop();
    }
  }

  Widget _buildButton(
    String nameButton,
    void Function() onTap,
    int flex,
  ) {
    return Expanded(
      flex: flex,
      child: SizedBox(
        height: 60,
        child: StreamBuilder<EventModelUI>(
            stream: _alertsInteractor.observerEventOfAlert,
            builder: (context, snapshot) {
              _eventModelUI = snapshot.data ?? _eventModelUI;
              return InkCustomButton(
                onTap: isChoose ? onTap : null,
                child: Container(
                  alignment: const Alignment(0, 0),
                  decoration: DesignStile.buttonDecoration(
                    color: isChoose ? DesignStile.primary : DesignStile.grey,
                    colorBorder: isChoose ? DesignStile.primary : DesignStile.grey,
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

  static const double _paddingDropdown = 30;
}
