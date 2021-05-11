import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/components/pikers/modal_piker.dart';
import 'package:cattle_scan/components/text_field/text_form.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'cow_update_interactor.dart';
import 'models/cow_update_model_ui.dart';

class CowSingleUpdateInfoPage extends StatefulWidget {
  const CowSingleUpdateInfoPage({
    Key key,
    @required this.animalId,
    @required this.bolusId,
    @required this.currentLactation,
    @required this.lactationStage,
  }) : super(key: key);

  final int animalId;
  final int bolusId;
  final String currentLactation;
  final String lactationStage;

  @override
  _CowSingleUpdateInfoPageState createState() => _CowSingleUpdateInfoPageState();
}

class _CowSingleUpdateInfoPageState extends State<CowSingleUpdateInfoPage> {
  CowUpdateInteractor _cowUpdateInteractor;
  CowUpdateModelUI _cowUpdateModelUI;
  final _f = DateFormat('dd/MMM/yyyy');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _cowUpdateInteractor = CowUpdateInteractor();
    _cowUpdateInteractor.setPreInfo(widget.animalId, widget.bolusId, widget.currentLactation, widget.lactationStage);
    super.initState();
  }

  @override
  void dispose() {
    _cowUpdateInteractor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Update cow information',
          style: DesignStile.textStyleAppBar,
        ),
      ),
      body: StreamBuilder<CowUpdateModelUI>(
          stream: _cowUpdateInteractor.observer,
          builder: (context, snapshot) {
            _cowUpdateModelUI = snapshot?.data ?? _cowUpdateModelUI;
            return Stack(
              alignment: const Alignment(0, 1),
              children: [
                Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 25),
                      _buildTitle(),
                      const SizedBox(height: 10),
                      _buildChangeLactationStage(),
                      const SizedBox(height: 10),
                      _buildDateLactationStart(),
                      const SizedBox(height: 600),
                    ],
                  ),
                ),
                _buildSaveButton(),
              ],
            );
          }),
    );
  }

  Text _buildTitle() {
    return Text(
      'Cow ${widget.animalId}',
      textAlign: TextAlign.center,
      style: DesignStile.textStyleCustom(
        color: DesignStile.dark,
        fontWeight: FontWeight.w900,
        fontSize: 24,
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
        listPikModels.firstWhere((e) => e.name == (_cowUpdateModelUI?.lactationStage ?? 'FRESH'));
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: CustomButtonModalPiker<String>(
        initialItem: initialItem,
        listPikModels: listPikModels,
        onTap: (lactationStage) {
          _cowUpdateInteractor.updateLactationStage(lactationStage);
        },
        child: TextFormDesign(
          controller: ValueNotifier(TextEditingController(text: _cowUpdateModelUI?.lactationStage ?? '')),
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
        height: 70,
        onTap: () async {
          DateTime initialDate;
          try {
            initialDate = _f.parse(_cowUpdateModelUI?.dateLactationStart ?? '');
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
          _cowUpdateInteractor.updateDateLactationStart(dateLactationStart);
        },
        child: TextFormDesign(
          keyboardType: TextInputType.number,
          controller: ValueNotifier(TextEditingController(text: _cowUpdateModelUI?.dateLactationStart ?? '')),
          labelText: 'Date of Start Lactation',
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: InkCustomButton(
        height: 50,
        onTap: () {
          _cowUpdateInteractor.uploadInfo();
        },
        child: Container(
          alignment: const Alignment(0, 0),
          decoration: DesignStile.buttonDecoration(
            blurRadius: 10,
            borderRadius: 40,
            offset: const Offset(0, 2),
            colorBorder: DesignStile.white,
            colorBoxShadow: DesignStile.red,
            color: DesignStile.primary,
          ),
          child: Text(
            'Save update',
            style: DesignStile.textStyleCustom(
              fontSize: 24,
              color: DesignStile.white,
            ),
          ),
        ),
      ),
    );
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
}
