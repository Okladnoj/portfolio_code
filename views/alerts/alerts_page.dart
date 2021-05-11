import 'package:cattle_scan/components/safe_text/safe_text.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/cow_single/interactor_cow_single.dart';
import 'package:flutter/material.dart';

import '../../components/formers/screen_former.dart';
import '../../components/formers/search_form.dart';

import 'alerts_interactor.dart';
import 'domain/filter_model.dart';
import 'models/alert_model_ui.dart';
import 'widgets/full_alert_card.dart';
import 'widgets/title.dart';

final _searchResult = <int>[];

class AlertsPage extends StatefulWidget {
  final FilterToAlerts filterToAlerts;
  final bool isInsideCow;

  const AlertsPage({
    Key key,
    this.filterToAlerts,
    @required this.isInsideCow,
  }) : super(key: key);
  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final _controllerTextSearch = TextEditingController();
  CowSingleInteractor _cowSingleInteractor;

  FilterToAlerts _filterToAlerts;
  AlertsInteractor _alertsInteractor;
  AlertsModelUI _alertModelUI;

  @override
  void initState() {
    _cowSingleInteractor = CowSingleInteractor();
    _filterToAlerts = widget.filterToAlerts;
    _alertsInteractor = AlertsInteractor();
    _alertsInteractor.loadDataFilter(_filterToAlerts);
    super.initState();
  }

  @override
  void dispose() {
    _alertsInteractor?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFormer(
      titleActions: TitleAlerts(nameTitle: _filterToAlerts.nameScreen),
      child: SearchForm(
        controller: _controllerTextSearch,
        onChanged: _onSearchTextChanged,
        onPressedClear: () {
          _onSearchTextChanged('');
        },
      ),
      children: [
        StreamBuilder<AlertsModelUI>(
          stream: _alertsInteractor.observer,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _alertModelUI = snapshot.data;
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _alertModelUI.listAlerts.length,
                itemBuilder: (BuildContext context, int i) {
                  final dataModel = _alertModelUI.listAlerts[i];

                  final _k = (i + 1) / 5;
                  if (_k > 1) {
                    print(i);
                  } else {}
                  _cowSingleInteractor.updateDataOfDay(dataModel.cowId, dataModel.bolusId);
                  return FullAlertCard(
                    isInsideCow: widget.isInsideCow,
                    alertModelUI: dataModel,
                    cowSingleInteractor: _cowSingleInteractor,
                    alertsInteractor: _alertsInteractor,
                  );
                },
              );
            } else {
              return SizedBox(
                height: 200,
                child: SafeText(
                  null,
                  style: DesignStile.textStyleCustom(fontSize: 80),
                ),
              );
            }
          },
        ),
        const SizedBox(height: 200),
      ],
    );
  }

  Future<void> _onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    setState(() {
      for (final cow in _alertModelUI.listAlerts) {
        final String cowId = cow.cowId.toString();
        if (cowId.contains(text)) {
          _searchResult.add(cow.cowId);
        }
      }
    });
  }
}
