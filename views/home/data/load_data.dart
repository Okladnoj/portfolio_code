import 'package:cattle_scan/api/api.dart';

import '../models/home_model.dart';
import '../models/home_model_repository.dart';

class HomeService {
  Future<HomeModels> getFarmInfo() async {
    final responseData1 = await CallApi.parsData('farmInfo/24h');
    final responseData2 = await CallApi.parsData('farmInfo/week');

    final r1 = RepositoryHome.fromJson(responseData1 as Map<String, dynamic>);
    final r2 = RepositoryHome.fromJson(responseData2 as Map<String, dynamic>);
    return HomeModels(
      r1?.status,
      CurrentPeriod.in24,
      _toData(r1?.data),
      _toData(r2?.data),
    );
  }

  HomeModel _toData(RepositoryData data) {
    return HomeModel(
      data.farmName,
      data.activeCows,
      data.in24Seen,
      data.highTemp,
      data.sustainTemp,
      data.lowTemp,
      data.waterIntake,
      data.calving,
      _toLactationStages(data.lactationStages),
      _toLactationStagesNames(data.lactationStagesNames),
      _toLactationGroups(data.lactationGroups),
    );
  }

  LactationStagesModel _toLactationStages(RepositoryLactationStages lactationStages) {
    return LactationStagesModel(
      lactationStages.noBred,
      lactationStages.preg,
      lactationStages.bred,
      lactationStages.okOpen,
      lactationStages.dry,
      lactationStages.fresh,
    );
  }

  LactationStagesNamesModel _toLactationStagesNames(RepositoryLactationStagesNames lactationStagesNames) {
    return LactationStagesNamesModel(
      lactationStagesNames.noBred,
      lactationStagesNames.preg,
      lactationStagesNames.bred,
      lactationStagesNames.okOpen,
      lactationStagesNames.dry,
      lactationStagesNames.fresh,
    );
  }

  LactationGroupsModel _toLactationGroups(RepositoryLactationGroups lactationGroups) {
    return LactationGroupsModel(
      lactationGroups.g1,
      lactationGroups.g2,
      lactationGroups.g3,
      lactationGroups.g4,
      lactationGroups.g5,
      lactationGroups.undefined,
    );
  }
}
