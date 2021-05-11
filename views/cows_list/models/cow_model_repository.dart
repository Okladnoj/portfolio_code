class CowsListModelRepository {
  final List<CowModelRepository> listCows;
  final String status;

  CowsListModelRepository(
    this.listCows,
    this.status,
  );

  CowsListModelRepository.fromJson(Map<String, dynamic> json)
      : listCows = _safeToCows(json),
        status = json['status'] as String;

  static List<CowModelRepository> _safeToCows(Map<String, dynamic> json) {
    List<CowModelRepository> _listCows;
    if (json['data'] != null) {
      _listCows = [];
      json['data'].forEach((v) {
        _listCows.add(CowModelRepository.fromJson(v as Map<String, dynamic>));
      });
    }
    return _listCows;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (listCows != null) {
      data['data'] = listCows.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class CowModelRepository {
  final int bolusId;
  final int animalId;
  final int opened;
  final int groups;
  final String lactations;

  CowModelRepository(
    this.bolusId,
    this.animalId,
    this.opened,
    this.groups,
    this.lactations,
  );

  CowModelRepository.fromJson(Map<String, dynamic> json)
      : bolusId = json['bolus_id'] as int,
        animalId = json['animal_id'] as int,
        opened = json['opened'] as int,
        groups = json['group'] as int,
        lactations = json['stage'] as String;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bolus_id'] = bolusId;
    data['animal_id'] = animalId;
    data['opened'] = opened;
    data['group'] = groups;
    data['stage'] = lactations;
    return data;
  }
}
