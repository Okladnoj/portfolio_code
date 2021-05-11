import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/components/formers/screen_former.dart';
import 'package:cattle_scan/components/pikers/modal_piker.dart';
import 'package:cattle_scan/components/text_field/text_form.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/alerts/widgets/title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'components/scan_qr_code.dart';
import 'cow_add_interactor.dart';
import 'models/cow_add_model.dart';
import 'models/cow_add_model_ui.dart';

class CowAddPage extends StatefulWidget {
  static const id = 'CowAddPage';

  const CowAddPage({Key key}) : super(key: key);

  @override
  _CowAddPageState createState() => _CowAddPageState();
}

class _CowAddPageState extends State<CowAddPage> {
  CowAddInteractor _cowAddInteractor;
  CowAddModelUI _cowAddModelUI;
  final _f = DateFormat('dd/MMM/yyyy');

  final TextEditingController _textEditingControllerBolusId = TextEditingController();

  ValueNotifier<TextEditingController> controllerFill(String string) => ValueNotifier(
        _textEditingControllerBolusId..text = string,
      );
  ValueNotifier<TextEditingController> controllerEmpty(String string) => null;
  ValueNotifier<TextEditingController> controller;

  @override
  void initState() {
    _cowAddInteractor = CowAddInteractor();
    super.initState();
  }

  @override
  void dispose() {
    _cowAddInteractor?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFormer(
      titleActions: _buildTitleAlerts(),
      bottomButton: _buildButtonSaveCow(),
      children: [
        _buildContent(),
      ],
    );
  }

  Widget _buildTitleAlerts() {
    return const TitleAlerts(nameTitle: 'Add new Cow');
  }

  Widget _buildContent() {
    return StreamBuilder<CowAddModelUI>(
      stream: _cowAddInteractor.observer,
      builder: (context, snapshot) {
        _cowAddModelUI = snapshot?.data ?? _cowAddModelUI;
        return Column(
          children: [
            const SizedBox(height: 20),
            _buildInputAnimalId(),
            const SizedBox(height: 20),
            _buildScanQrCode(),
            const SizedBox(height: 20),
            _buildLabelBolusId(),
            const SizedBox(height: 20),
            _buildValidateAlert(),
            const SizedBox(height: 20),
            _buildParametersList(),
          ],
        );
      },
    );
  }

  Widget _buildTitles(String string) {
    return Text(
      string,
      style: DesignStile.textStyleCustom(fontSize: 24),
    );
  }

  Widget _buildInputAnimalId() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Container(
            alignment: const Alignment(-1, 0),
            width: 120,
            child: _buildTitles('Animal ID: '),
          ),
          Expanded(
            child: TextFormDesign(
              keyboardType: TextInputType.phone,
              hintText: 'Enter animal Id',
              onChanged: (animalId) {
                _cowAddInteractor.onChangeAnimalId(animalId);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanQrCode() {
    return ScanQrCode(
      isEnable: ValueNotifier(_cowAddModelUI?.animalId?.isNotEmpty ?? false),
      onChanged: (bolusId) async {
        controller = controllerFill(bolusId);
        await _cowAddInteractor.onChangeBolusId(bolusId);
      },
    );
  }

  Widget _buildLabelBolusId() {
    String string = _cowAddModelUI?.bolusId ?? '';
    final isEnable = string.isNotEmpty;
    Color colorBorder;
    if (isEnable) {
      string = string;
      colorBorder = DesignStile.dark;
    } else {
      string = '';
      colorBorder = DesignStile.disable;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Container(
            alignment: const Alignment(-1, 0),
            width: 120,
            child: _buildTitles('Bolus ID: '),
          ),
          Expanded(
            child: Container(
              height: _hightField,
              width: double.maxFinite,
              alignment: const Alignment(0, 0),
              child: TextFormDesign(
                controller: controller,
                keyboardType: TextInputType.phone,
                hintText: 'Enter bolus ID',
                style: ValueNotifier(DesignStile.textStyleCustom(
                  color: colorBorder,
                  fontSize: 20,
                )),
                onChanged: (animalId) {
                  controller = controllerEmpty(string);
                  _cowAddInteractor.onChangeBolusId(animalId);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidateAlert() {
    final checkCow = _cowAddModelUI?.checkCow;
    String text;
    Color colorText;

    if (_cowAddModelUI?.animalId?.isEmpty ?? true) {
      return Container();
    }
    if (checkCow == null) {
      return Container();
    } else if (checkCow == CheckCow.present) {
      text = 'This cow Present';
      colorText = DesignStile.primary;
    } else if (checkCow == CheckCow.absent) {
      text = 'You can add this Cow';
      colorText = DesignStile.green;
    } else if (checkCow == CheckCow.error) {
      text = 'Some error';
      colorText = DesignStile.primary;
    }
    return Container(
      height: 50,
      width: double.infinity,
      alignment: const Alignment(0, 0),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: DesignStile.buttonDecoration(
        colorBorder: colorText,
      ),
      child: Text(
        text,
        style: DesignStile.textStyleCustom(
          color: colorText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildParametersList() {
    final isValidate = _cowAddModelUI?.isValidate ?? false;
    return isValidate
        ? Column(children: [
            _buildChangeDateOfBirth(),
            const SizedBox(height: 10),
            _buildChangeLactationNumber(),
            const SizedBox(height: 10),
            _buildChangeLactationStage(),
            const SizedBox(height: 10),
            _buildDateLactationStart(),
            const SizedBox(height: 600),
          ])
        : const Text('');
  }

  Widget _buildChangeDateOfBirth() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkCustomButton(
        height: _hightField,
        onTap: () async {
          DateTime initialDate;
          try {
            initialDate = _f.parse(_cowAddModelUI?.dateOfBirth ?? '');
          } catch (e) {
            initialDate = DateTime.now();
          }

          final data = await _pickedDateTime(context, initialDate);
          // final time = await _pickedTime(context);
          final dateOfBirth = DateTime(
            data.year,
            data.month,
            data.day,
            //  time.hour,
            //  time.minute,
          );
          _cowAddInteractor.onChangeDateOfBirth(dateOfBirth);
        },
        child: TextFormDesign(
          keyboardType: TextInputType.number,
          controller: ValueNotifier(TextEditingController(text: _cowAddModelUI?.dateOfBirth ?? '')),
          labelText: 'Date of Birth',
        ),
      ),
    );
  }

  Widget _buildChangeLactationNumber() {
    final List<PikModel<int>> listPikModels = List.generate(10, (i) => PikModel(i, '${i + 1}', i + 1));
    final PikModel<int> initialItem =
        listPikModels.firstWhere((e) => e.name == (_cowAddModelUI?.lactationNumber ?? '1'));
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: CustomButtonModalPiker<int>(
        initialItem: initialItem,
        listPikModels: listPikModels,
        onTap: (lactationNumber) {
          _cowAddInteractor.onChangeLactationNumber(lactationNumber);
        },
        child: TextFormDesign(
          controller: ValueNotifier(TextEditingController(text: _cowAddModelUI?.lactationNumber ?? '')),
          keyboardType: TextInputType.phone,
          labelText: 'Lactation number',
          hintText: 'Choose lactation number',
          onChanged: (lactationNumber) {},
        ),
      ),
    );
  }

  Widget _buildChangeLactationStage() {
    int i = 0;
    final List<PikModel<String>> listPikModels = listLactationStage
            ?.map((e) => PikModel<String>(
                  i++,
                  e,
                  e,
                ))
            ?.toList() ??
        [];
    final PikModel<String> initialItem =
        listPikModels.firstWhere((e) => e.name == (_cowAddModelUI?.lactationStage ?? 'FRESH'));
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: CustomButtonModalPiker<String>(
        initialItem: initialItem,
        listPikModels: listPikModels,
        onTap: (lactationStage) {
          _cowAddInteractor.onChangeLactationStage(lactationStage);
        },
        child: TextFormDesign(
          controller: ValueNotifier(TextEditingController(text: _cowAddModelUI?.lactationStage ?? '')),
          keyboardType: TextInputType.text,
          labelText: 'Lactation stage',
          hintText: 'Enter lactation stage',
          onChanged: (lactationStage) {},
        ),
      ),
    );
  }

  Widget _buildDateLactationStart() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkCustomButton(
        height: _hightField,
        onTap: () async {
          DateTime initialDate;
          try {
            initialDate = _f.parse(_cowAddModelUI?.dateLactationStart ?? '');
          } catch (e) {
            initialDate = DateTime.now();
          }

          final data = await _pickedDateTime(context, initialDate);
          // final time = await _pickedTime(context);
          final dateLactationStart = DateTime(
            data.year,
            data.month,
            data.day,
            //  time.hour,
            //  time.minute,
          );
          _cowAddInteractor.onChangeDateLactationStart(dateLactationStart);
        },
        child: TextFormDesign(
          keyboardType: TextInputType.number,
          controller: ValueNotifier(TextEditingController(text: _cowAddModelUI?.dateLactationStart ?? '')),
          labelText: 'Date of Start Lactation',
        ),
      ),
    );
  }

  Widget _buildButtonSaveCow() {
    return StreamBuilder<CowAddModelUI>(
        stream: _cowAddInteractor?.observer,
        builder: (context, snapshot) {
          _cowAddModelUI = snapshot?.data ?? _cowAddModelUI;
          const isValidate = false; //  _cowAddModelUI?.isValidate ?? false;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: InkCustomButton(
              height: 50,
              onTap: isValidate
                  ? () {
                      _cowAddInteractor.onSaveCow();
                    }
                  : null,
              child: Container(
                alignment: const Alignment(0, 0),
                decoration: DesignStile.buttonDecoration(
                  blurRadius: 10,
                  borderRadius: 40,
                  offset: const Offset(0, 2),
                  colorBorder: isValidate ? DesignStile.white : DesignStile.disable,
                  colorBoxShadow: isValidate ? DesignStile.red : DesignStile.black,
                  color: isValidate ? DesignStile.primary : DesignStile.grey,
                ),
                child: Text(
                  'Save Cow',
                  style: DesignStile.textStyleCustom(
                    fontSize: 24,
                    color: isValidate ? DesignStile.white : DesignStile.disable,
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<TimeOfDay> _pickedTime(BuildContext context, [TimeOfDay initialTime]) => showTimePicker(
        initialTime: initialTime ?? TimeOfDay.now(),
        context: context,
      );
  Future<DateTime> _pickedDateTime(BuildContext context, DateTime initialDate) => showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
      );

  static const double _hightField = 70;
}
