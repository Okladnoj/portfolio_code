import 'dart:async';

import 'data/load_data.dart';
import 'models/cow_model.dart';
import 'models/cows_list_ui.dart';

class CowsListInteractor {
  static List<Cow> _listCow;
  static CowsListModelUI cowsListModelUI;

  CowsListInteractor() {
    _init();
  }

  final StreamController<CowsListModelUI> _controller = StreamController.broadcast();
  StreamSink<CowsListModelUI> get sink => _controller.sink;
  Stream<CowsListModelUI> get observer => _controller.stream;

  void dispose() {
    _controller.close();
  }

  Future<void> _init() async {
    await loadListCows();
    _updateUI();
  }

  Future<void> loadListCows() async {
    _listCow = await getCowsList();
  }

  void _updateUI() {
    cowsListModelUI = CowsListModelUI(_listCow);

    sink.add(cowsListModelUI);
  }

  void updateUI() {
    sink.add(cowsListModelUI);
  }

  void changeShowRead(bool showRead) {
    cowsListModelUI.showRead = showRead;
    updateUI();
  }

  void changeShowUnRead(bool showUnRead) {
    cowsListModelUI.showUnRead = showUnRead;
    updateUI();
  }

  void changeShowStages(String showStages) {
    final isContains = cowsListModelUI.showStages.contains(showStages);
    if (isContains) {
      cowsListModelUI.showStages.remove(showStages);
    } else {
      cowsListModelUI.showStages.add(showStages);
    }
    updateUI();
  }

  void changeShowGroups(int showGroups) {
    final isContains = cowsListModelUI.showGroups.contains(showGroups);
    if (isContains) {
      cowsListModelUI.showGroups.remove(showGroups);
    } else {
      cowsListModelUI.showGroups.add(showGroups);
    }
    updateUI();
  }
}
