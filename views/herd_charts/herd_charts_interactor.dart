import 'dart:async';

import 'domain/herd_charts_load_data.dart';
import 'models/herd_charts_model.dart';
import 'models/herd_charts_model_ui.dart';

class HerdChartsInteractor {
  HerdChartsInteractor() {
    _init();
  }

  final StreamController<HerdChartsModelUI> _controller = StreamController.broadcast();
  StreamSink<HerdChartsModelUI> get sink => _controller.sink;
  Stream<HerdChartsModelUI> get observer => _controller.stream;

  HerdChartsModel _herdChartsModel;
  HerdChartsService _herdChartsService;

  void dispose() {
    _controller.close();
  }

  void switchDayHoursTemperature(TimeInterval timeInterval) {
    _herdChartsModel = _herdChartsModel.copy(
      temperature: _herdChartsModel.temperature.copy(timeInterval: timeInterval),
    );
    _updateUI();
  }

  void switchDayHoursWater(TimeInterval timeInterval) {
    _herdChartsModel = _herdChartsModel.copy(
      water: _herdChartsModel.water.copy(timeInterval: timeInterval),
    );
    _updateUI();
  }

  void switchGroupLactationsTemperature(SubGroupOfCharts subGroup) {
    _herdChartsModel = _herdChartsModel.copy(
      temperature: _herdChartsModel.temperature.copy(subGroup: subGroup),
    );
    _updateUI();
  }

  void switchGroupLactationsWater(SubGroupOfCharts subGroup) {
    _herdChartsModel = _herdChartsModel.copy(
      water: _herdChartsModel.water.copy(subGroup: subGroup),
    );
    _updateUI();
  }

  void dateChangeTemperature(DateTime date) {
    _loadTemperatureModel(date);
  }

  void dateChangeWater(DateTime date) {
    _loadWaterModel(date);
  }

  void offOnGroupsGraphicTemperature(bool isDay, ActionLineOfGroups actionLineOfGroups) {
    if (isDay) {
      GroupsDaysModel groupsDays = _herdChartsModel.temperature.groups.groupsDays;
      switch (actionLineOfGroups) {
        case ActionLineOfGroups.g1:
          final g = groupsDays.g1;
          groupsDays = groupsDays.copy(g1: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g2:
          final g = groupsDays.g2;
          groupsDays = groupsDays.copy(g2: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g3:
          final g = groupsDays.g3;
          groupsDays = groupsDays.copy(g3: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g4:
          final g = groupsDays.g4;
          groupsDays = groupsDays.copy(g4: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g5:
          final g = groupsDays.g5;
          groupsDays = groupsDays.copy(g5: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.undefined:
          final g = groupsDays.undefined;
          groupsDays = groupsDays.copy(undefined: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.total:
          final g = groupsDays.total;
          groupsDays = groupsDays.copy(total: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.outside:
          final g = groupsDays.outside;
          groupsDays = groupsDays.copy(outside: g.copy(isShow: !g.isShow));
          break;
        default:
      }
      _herdChartsModel = _herdChartsModel.copy(
          temperature: _herdChartsModel.temperature.copy(
        groups: _herdChartsModel.temperature.groups.copy(groupsDays: groupsDays),
      ));
    } else {
      GroupsHoursModel groupsHours = _herdChartsModel.temperature.groups.groupsHours;
      switch (actionLineOfGroups) {
        case ActionLineOfGroups.g1:
          final g = groupsHours.g1;
          groupsHours = groupsHours.copy(g1: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g2:
          final g = groupsHours.g2;
          groupsHours = groupsHours.copy(g2: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g3:
          final g = groupsHours.g3;
          groupsHours = groupsHours.copy(g3: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g4:
          final g = groupsHours.g4;
          groupsHours = groupsHours.copy(g4: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g5:
          final g = groupsHours.g5;
          groupsHours = groupsHours.copy(g5: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.undefined:
          final g = groupsHours.undefined;
          groupsHours = groupsHours.copy(undefined: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.total:
          final g = groupsHours.total;
          groupsHours = groupsHours.copy(total: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.outside:
          final g = groupsHours.outside;
          groupsHours = groupsHours.copy(outside: g.copy(isShow: !g.isShow));
          break;
        default:
      }
      _herdChartsModel = _herdChartsModel.copy(
          temperature: _herdChartsModel.temperature.copy(
        groups: _herdChartsModel.temperature.groups.copy(groupsHours: groupsHours),
      ));
    }

    _updateUI();
  }

  void offOnGroupsGraphicWater(bool isDay, ActionLineOfGroups actionLineOfGroups) {
    if (isDay) {
      GroupsDaysModel groupsDays = _herdChartsModel.water.groups.groupsDays;
      switch (actionLineOfGroups) {
        case ActionLineOfGroups.g1:
          final g = groupsDays.g1;
          groupsDays = groupsDays.copy(g1: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g2:
          final g = groupsDays.g2;
          groupsDays = groupsDays.copy(g2: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g3:
          final g = groupsDays.g3;
          groupsDays = groupsDays.copy(g3: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g4:
          final g = groupsDays.g4;
          groupsDays = groupsDays.copy(g4: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g5:
          final g = groupsDays.g5;
          groupsDays = groupsDays.copy(g5: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.undefined:
          final g = groupsDays.undefined;
          groupsDays = groupsDays.copy(undefined: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.total:
          final g = groupsDays.total;
          groupsDays = groupsDays.copy(total: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.outside:
          final g = groupsDays.outside;
          groupsDays = groupsDays.copy(outside: g.copy(isShow: !g.isShow));
          break;
        default:
      }
      _herdChartsModel = _herdChartsModel.copy(
          water: _herdChartsModel.water.copy(
        groups: _herdChartsModel.water.groups.copy(groupsDays: groupsDays),
      ));
    } else {
      GroupsHoursModel groupsHours = _herdChartsModel.water.groups.groupsHours;
      switch (actionLineOfGroups) {
        case ActionLineOfGroups.g1:
          final g = groupsHours.g1;
          groupsHours = groupsHours.copy(g1: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g2:
          final g = groupsHours.g2;
          groupsHours = groupsHours.copy(g2: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g3:
          final g = groupsHours.g3;
          groupsHours = groupsHours.copy(g3: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g4:
          final g = groupsHours.g4;
          groupsHours = groupsHours.copy(g4: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.g5:
          final g = groupsHours.g5;
          groupsHours = groupsHours.copy(g5: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.undefined:
          final g = groupsHours.undefined;
          groupsHours = groupsHours.copy(undefined: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.total:
          final g = groupsHours.total;
          groupsHours = groupsHours.copy(total: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfGroups.outside:
          final g = groupsHours.outside;
          groupsHours = groupsHours.copy(outside: g.copy(isShow: !g.isShow));
          break;
        default:
      }
      _herdChartsModel = _herdChartsModel.copy(
          water: _herdChartsModel.water.copy(
        groups: _herdChartsModel.water.groups.copy(groupsHours: groupsHours),
      ));
    }
    _updateUI();
  }

  void offOnLactationsGraphicTemperature(bool isDay, ActionLineOfLactations actionLineOfLactations) {
    if (isDay) {
      LactationsDaysModel lactationsDays = _herdChartsModel.temperature.lactations.lactationsDays;
      switch (actionLineOfLactations) {
        case ActionLineOfLactations.bred:
          final g = lactationsDays.bred;
          lactationsDays = lactationsDays.copy(bred: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.dry:
          final g = lactationsDays.dry;
          lactationsDays = lactationsDays.copy(dry: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.fresh:
          final g = lactationsDays.fresh;
          lactationsDays = lactationsDays.copy(fresh: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.noBred:
          final g = lactationsDays.noBred;
          lactationsDays = lactationsDays.copy(noBred: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.okOpen:
          final g = lactationsDays.okOpen;
          lactationsDays = lactationsDays.copy(okOpen: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.preg:
          final g = lactationsDays.preg;
          lactationsDays = lactationsDays.copy(preg: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.undefined:
          final g = lactationsDays.undefined;
          lactationsDays = lactationsDays.copy(undefined: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.total:
          final g = lactationsDays.total;
          lactationsDays = lactationsDays.copy(total: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.outside:
          final g = lactationsDays.outside;
          lactationsDays = lactationsDays.copy(outside: g.copy(isShow: !g.isShow));
          break;

        default:
      }
      _herdChartsModel = _herdChartsModel.copy(
          temperature: _herdChartsModel.temperature.copy(
        lactations: _herdChartsModel.temperature.lactations.copy(lactationsDays: lactationsDays),
      ));
    } else {
      LactationsHoursModel lactationsHours = _herdChartsModel.temperature.lactations.lactationsHours;
      switch (actionLineOfLactations) {
        case ActionLineOfLactations.bred:
          final g = lactationsHours.bred;
          lactationsHours = lactationsHours.copy(bred: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.dry:
          final g = lactationsHours.dry;
          lactationsHours = lactationsHours.copy(dry: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.fresh:
          final g = lactationsHours.fresh;
          lactationsHours = lactationsHours.copy(fresh: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.noBred:
          final g = lactationsHours.noBred;
          lactationsHours = lactationsHours.copy(noBred: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.okOpen:
          final g = lactationsHours.okOpen;
          lactationsHours = lactationsHours.copy(okOpen: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.preg:
          final g = lactationsHours.preg;
          lactationsHours = lactationsHours.copy(preg: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.undefined:
          final g = lactationsHours.undefined;
          lactationsHours = lactationsHours.copy(undefined: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.total:
          final g = lactationsHours.total;
          lactationsHours = lactationsHours.copy(total: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.outside:
          final g = lactationsHours.outside;
          lactationsHours = lactationsHours.copy(outside: g.copy(isShow: !g.isShow));
          break;

        default:
      }
      _herdChartsModel = _herdChartsModel.copy(
          temperature: _herdChartsModel.temperature.copy(
        lactations: _herdChartsModel.temperature.lactations.copy(lactationsHours: lactationsHours),
      ));
    }
    _updateUI();
  }

  void offOnLactationsGraphicWater(bool isDay, ActionLineOfLactations actionLineOfLactations) {
    if (isDay) {
      LactationsDaysModel lactationsDays = _herdChartsModel.water.lactations.lactationsDays;
      switch (actionLineOfLactations) {
        case ActionLineOfLactations.bred:
          final g = lactationsDays.bred;
          lactationsDays = lactationsDays.copy(bred: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.dry:
          final g = lactationsDays.dry;
          lactationsDays = lactationsDays.copy(dry: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.fresh:
          final g = lactationsDays.fresh;
          lactationsDays = lactationsDays.copy(fresh: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.noBred:
          final g = lactationsDays.noBred;
          lactationsDays = lactationsDays.copy(noBred: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.okOpen:
          final g = lactationsDays.okOpen;
          lactationsDays = lactationsDays.copy(okOpen: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.preg:
          final g = lactationsDays.preg;
          lactationsDays = lactationsDays.copy(preg: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.undefined:
          final g = lactationsDays.undefined;
          lactationsDays = lactationsDays.copy(undefined: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.total:
          final g = lactationsDays.total;
          lactationsDays = lactationsDays.copy(total: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.outside:
          final g = lactationsDays.outside;
          lactationsDays = lactationsDays.copy(outside: g.copy(isShow: !g.isShow));
          break;

        default:
      }
      _herdChartsModel = _herdChartsModel.copy(
          water: _herdChartsModel.water.copy(
        lactations: _herdChartsModel.water.lactations.copy(lactationsDays: lactationsDays),
      ));
    } else {
      LactationsHoursModel lactationsHours = _herdChartsModel.water.lactations.lactationsHours;
      switch (actionLineOfLactations) {
        case ActionLineOfLactations.bred:
          final g = lactationsHours.bred;
          lactationsHours = lactationsHours.copy(bred: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.dry:
          final g = lactationsHours.dry;
          lactationsHours = lactationsHours.copy(dry: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.fresh:
          final g = lactationsHours.fresh;
          lactationsHours = lactationsHours.copy(fresh: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.noBred:
          final g = lactationsHours.noBred;
          lactationsHours = lactationsHours.copy(noBred: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.okOpen:
          final g = lactationsHours.okOpen;
          lactationsHours = lactationsHours.copy(okOpen: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.preg:
          final g = lactationsHours.preg;
          lactationsHours = lactationsHours.copy(preg: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.undefined:
          final g = lactationsHours.undefined;
          lactationsHours = lactationsHours.copy(undefined: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.total:
          final g = lactationsHours.total;
          lactationsHours = lactationsHours.copy(total: g.copy(isShow: !g.isShow));
          break;
        case ActionLineOfLactations.outside:
          final g = lactationsHours.outside;
          lactationsHours = lactationsHours.copy(outside: g.copy(isShow: !g.isShow));
          break;

        default:
      }
      _herdChartsModel = _herdChartsModel.copy(
          water: _herdChartsModel.water.copy(
        lactations: _herdChartsModel.water.lactations.copy(lactationsHours: lactationsHours),
      ));
    }
    _updateUI();
  }

  void _init() {
    _herdChartsModel = HerdChartsModel.empty();
    _herdChartsService = HerdChartsService();
    _loadTemperatureModel();
    _loadWaterModel();
  }

  Future<void> _loadTemperatureModel([DateTime date]) async {
    final _date = date ?? DateTime.now();
    TemperatureModel temperatureModel = await _herdChartsService.loadTemperatureLactationsDay(_date);
    _herdChartsModel = _herdChartsModel.copy(temperature: temperatureModel);
    temperatureModel = await _herdChartsService.loadTemperatureLactationsHour(_date);
    _herdChartsModel = _herdChartsModel.copy(temperature: temperatureModel);
    _updateUI();

    temperatureModel = await _herdChartsService.loadTemperatureGroupDay(_date);
    _herdChartsModel = _herdChartsModel.copy(temperature: temperatureModel);
    temperatureModel = await _herdChartsService.loadTemperatureGroupHour(_date);
    _herdChartsModel = _herdChartsModel.copy(temperature: temperatureModel);
    _updateUI();
  }

  Future<void> _loadWaterModel([DateTime date]) async {
    final _date = date ?? DateTime.now();
    WaterModel waterModel = await _herdChartsService.loadWaterLactationsDay(_date);
    _herdChartsModel = _herdChartsModel.copy(water: waterModel);
    waterModel = await _herdChartsService.loadWaterLactationsHour(_date);
    _herdChartsModel = _herdChartsModel.copy(water: waterModel);
    _updateUI();

    waterModel = await _herdChartsService.loadWaterGroupDay(_date);
    _herdChartsModel = _herdChartsModel.copy(water: waterModel);
    waterModel = await _herdChartsService.loadWaterGroupHour(_date);
    _herdChartsModel = _herdChartsModel.copy(water: waterModel);
    _updateUI();
  }

  void _updateUI() {
    sink.add(_mapToUI());
  }

  HerdChartsModelUI _mapToUI() {
    return HerdChartsModelUI(
      _mapToWaterModelUI(_herdChartsModel?.water),
      _mapToTemperatureModelUI(_herdChartsModel?.temperature),
    );
  }

  WaterModelUI _mapToWaterModelUI(WaterModel water) {
    return WaterModelUI(
      water?.timeInterval,
      water?.subGroup,
      _mapToGroupsModelUI(water?.groups),
      _mapToLactationsModelUI(water?.lactations),
      water?.date,
      water?.isLoad,
    );
  }

  GroupsModelUI _mapToGroupsModelUI(GroupsModel groups) {
    return GroupsModelUI(
      _mapToGroupsDaysModelUI(groups?.groupsDays),
      _mapToGroupsHoursModelUI(groups?.groupsHours),
    );
  }

  GroupsDaysModelUI _mapToGroupsDaysModelUI(GroupsDaysModel groups) {
    return GroupsDaysModelUI(
      groups?.day,
      _mapToGraphicModelUI(groups?.g1),
      _mapToGraphicModelUI(groups?.g2),
      _mapToGraphicModelUI(groups?.g3),
      _mapToGraphicModelUI(groups?.g4),
      _mapToGraphicModelUI(groups?.g5),
      _mapToGraphicModelUI(groups?.undefined),
      _mapToGraphicModelUI(groups?.total),
      _mapToGraphicModelUI(groups?.outside),
    );
  }

  GroupsHoursModelUI _mapToGroupsHoursModelUI(GroupsHoursModel groups) {
    return GroupsHoursModelUI(
      groups?.hour,
      _mapToGraphicModelUI(groups?.g1),
      _mapToGraphicModelUI(groups?.g2),
      _mapToGraphicModelUI(groups?.g3),
      _mapToGraphicModelUI(groups?.g4),
      _mapToGraphicModelUI(groups?.g5),
      _mapToGraphicModelUI(groups?.undefined),
      _mapToGraphicModelUI(groups?.total),
      _mapToGraphicModelUI(groups?.outside),
    );
  }

  LactationsModelUI _mapToLactationsModelUI(LactationsModel lactations) {
    return LactationsModelUI(
      _mapToListLactationsDaysModelUI(lactations?.lactationsDays),
      _mapToListLactationsHoursModelUI(lactations?.lactationsHours),
    );
  }

  LactationsDaysModelUI _mapToListLactationsDaysModelUI(LactationsDaysModel lactations) {
    return LactationsDaysModelUI(
      lactations?.day,
      _mapToGraphicModelUI(lactations?.bred),
      _mapToGraphicModelUI(lactations?.dry),
      _mapToGraphicModelUI(lactations?.fresh),
      _mapToGraphicModelUI(lactations?.noBred),
      _mapToGraphicModelUI(lactations?.okOpen),
      _mapToGraphicModelUI(lactations?.preg),
      _mapToGraphicModelUI(lactations?.undefined),
      _mapToGraphicModelUI(lactations?.total),
      _mapToGraphicModelUI(lactations?.outside),
    );
  }

  LactationsHoursModelUI _mapToListLactationsHoursModelUI(LactationsHoursModel lactations) {
    return LactationsHoursModelUI(
      lactations?.hour,
      _mapToGraphicModelUI(lactations?.bred),
      _mapToGraphicModelUI(lactations?.dry),
      _mapToGraphicModelUI(lactations?.fresh),
      _mapToGraphicModelUI(lactations?.noBred),
      _mapToGraphicModelUI(lactations?.okOpen),
      _mapToGraphicModelUI(lactations?.preg),
      _mapToGraphicModelUI(lactations?.undefined),
      _mapToGraphicModelUI(lactations?.total),
      _mapToGraphicModelUI(lactations?.outside),
    );
  }

  GraphicModelUI _mapToGraphicModelUI(GraphicModel g) {
    return GraphicModelUI(
      g?.name,
      g?.data,
      g?.type,
      g?.color,
      g?.isShow,
    );
  }

  TemperatureModelUI _mapToTemperatureModelUI(TemperatureModel temperature) {
    return TemperatureModelUI(
      temperature?.timeInterval,
      temperature?.subGroup,
      _mapToGroupsModelUI(temperature?.groups),
      _mapToLactationsModelUI(temperature?.lactations),
      temperature?.date,
      temperature?.isLoad,
    );
  }
}
