import 'cow_model.dart';

List<String> kShowStages = [
  'BRED',
  'DRY',
  'FRESH',
  'NOBRED',
  'OK/OPEN',
  'PREG',
];
List<int> kShowGroups = [
  1,
  2,
  3,
  4,
  5,
  6,
];

class CowsListModelUI {
  final List<Cow> _listCows;
  List<Cow> get listCows => _getCows();
  final List<String> items = List<String>.generate(50, (i) => "Cow ${i + 1}");
  bool showRead = true;
  bool showUnRead = true;
  List<String> showStages = kShowStages.map((e) => e).toList();
  List<int> showGroups = kShowGroups.map((e) => e).toList();

  CowsListModelUI(this._listCows);

  List<Cow> _getCows() {
    final List<Cow> listCows = [];

    for (final e in _listCows) {
      if (showUnRead) {
        final isSow = e?.hasUnreadAlert ?? false;
        if (isSow) {
          final isShowStages = showStages.contains(e?.lactations);
          final isShowGroups = showGroups.contains(e?.groups);
          if (isShowStages && isShowGroups) {
            listCows.add(
              Cow(
                animalId: e?.animalId,
                bolusId: e?.bolusId,
                name: e?.name,
                hasUnreadAlert: e?.hasUnreadAlert,
                groups: e?.groups,
                lactations: e?.lactations,
              ),
            );
          }
        }
      }
      if (showRead) {
        final isSow = !(e?.hasUnreadAlert ?? false);
        if (isSow) {
          final isShowStages = showStages.contains(e?.lactations);
          final isShowGroups = showGroups.contains(e?.groups);
          if (isShowStages && isShowGroups) {
            listCows.add(
              Cow(
                animalId: e?.animalId,
                bolusId: e?.bolusId,
                name: e?.name,
                hasUnreadAlert: e?.hasUnreadAlert,
                groups: e?.groups,
                lactations: e?.lactations,
              ),
            );
          }
        }
      }
    }
    return listCows;
  }
}
