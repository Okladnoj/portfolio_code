import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/components/buttons/add_cow_buttom.dart';
import 'package:cattle_scan/components/formers/search_form.dart';
import 'package:cattle_scan/components/logic/text_format.dart';
import 'package:cattle_scan/settings/constants.dart';
import "package:flutter/material.dart";

import '../cow_single/interactor_cow_single.dart';
import 'interactor_cows_list.dart';
import 'models/cow_model.dart';
import 'models/cows_list_ui.dart';
import 'widgets/filter_alert.dart';

final _searchResult = <Cow>[];

class CowsListPage extends StatefulWidget {
  static const id = 'CowsListPage';

  const CowsListPage({Key key}) : super(key: key);
  @override
  _CowsListPageState createState() => _CowsListPageState();
}

class _CowsListPageState extends State<CowsListPage> {
  CowsListModelUI _cowsListModelUI;

  CowsListInteractor _cowsListInteractor;
  CowSingleInteractor _cowSingleInteractor;

  TextEditingController controller = TextEditingController();

  bool get _isLoading => !(_cowsListModelUI?.listCows?.isNotEmpty ?? false);
  bool get _isSearch => _searchResult.isNotEmpty || controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _cowsListInteractor = CowsListInteractor();
    _cowSingleInteractor = CowSingleInteractor();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _cowsListInteractor.updateUI();
    });
    controller.clear();
    _loadListCows();
    _onSearchTextChanged('');
  }

  @override
  void dispose() {
    _cowSingleInteractor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CowsListModelUI>(
        stream: _cowsListInteractor.observer,
        builder: (context, snapshot) {
          _cowsListModelUI = snapshot?.data ?? _cowsListModelUI;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'List of cows',
                style: DesignStile.textStyleAppBar,
              ),
              centerTitle: true,
              actions: [_buildFilterButton(context)],
            ),
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
                    ),
                  )
                : Stack(
                    alignment: const Alignment(0, 1),
                    children: [
                      Column(
                        children: [
                          SearchForm(
                            controller: controller,
                            onChanged: _onSearchTextChanged,
                            onPressedClear: () {
                              _onSearchTextChanged('');
                            },
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              color: Colors.black,
                              onRefresh: _loadListCows,
                              child: _buildCowsList(),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: AddCowButton(
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
          );
        });
  }

  Widget _buildFilterButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.filter_alt_outlined,
        color: DesignStile.white,
        size: 30,
      ),
      onPressed: () async {
        AppNavigator.dialog(
          FilterAlert(
            cowsListInteractor: _cowsListInteractor,
            cowsListModelUI: _cowsListModelUI,
          ),
        );
      },
    );
  }

  Widget _buildCowsList() {
    final _listCow = _isSearch ? _searchResult : _cowsListModelUI.listCows;
    return ListView.builder(
      itemCount: _listCow.length,
      itemBuilder: (BuildContext context, int index) {
        final cow = _listCow[index];
        double bottom = 0.0;
        if (index == _listCow.length - 1) {
          bottom = 150.0;
        }
        // _cowSingleInteractor.updateDataOfDay(cow.animalId, cow.bolusId);
        return Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: InkWell(
            onTap: () {
              AppNavigator.navigateToCowSinglePage(cow.animalId, cow.bolusId, _cowSingleInteractor);
            },
            child: ListTile(
              leading: Icon(
                cow.hasUnreadAlert ? Icons.email : Icons.drafts,
                color: cow.hasUnreadAlert ? Colors.red : Colors.black,
              ),
              trailing: const Icon(Icons.keyboard_arrow_right),
              title: Text(gMascCow(cow.name, cow.animalId)),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    setState(() {
      for (final cow in _cowsListModelUI.listCows) {
        final String cowId = (cow.animalId * DesignStile.maskCode).toString();
        if (cowId.contains(text)) {
          _searchResult.add(cow);
        }
      }
    });
  }

  Future<void> _loadListCows() async {
    await _cowsListInteractor.loadListCows();
  }
}
