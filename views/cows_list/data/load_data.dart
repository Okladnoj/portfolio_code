import 'package:cattle_scan/api/api.dart';
import 'package:cattle_scan/views/cows_list/models/cow_model_repository.dart';

import '../models/cow_model.dart';

Future<List<Cow>> getCowsList() async {
  List<Cow> listCows;
  try {
    final responseData = await CallApi.parsData('getAnimalList');

    if (responseData != null) {
      final r = CowsListModelRepository.fromJson(responseData as Map<String, dynamic>);
      listCows = r?.listCows
              ?.map((e) => Cow(
                    animalId: e.animalId,
                    bolusId: e.bolusId,
                    name: 'Cow ${e.animalId}',
                    hasUnreadAlert: e.opened == 1,
                    groups: e.groups,
                    lactations: e.lactations,
                  ))
              ?.toList() ??
          [];

      print('Load Successful');
    } else {
      print('Status: ${responseData['status']}');
    }
  } catch (e) {
    print('Cow model don\'t fill!\ndir:"lib\\core\\cows_list\\data\\load_data.dart"');
  }
  return listCows;
}
