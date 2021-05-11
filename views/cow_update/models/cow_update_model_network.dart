import 'package:freezed_annotation/freezed_annotation.dart';

part 'cow_update_model_network.g.dart';

@JsonSerializable()
class CowUpdateModelRepository {
  @JsonKey(name: "animal_id")
  final int animalId;
  @JsonKey(name: "lactation_stage")
  final String lactationStage;
  @JsonKey(name: "date_lactation_start")
  final String dateLactationStart;

  CowUpdateModelRepository(
    this.animalId,
    this.lactationStage,
    this.dateLactationStart,
  );

  factory CowUpdateModelRepository.fromJson(Map<String, dynamic> json) => _$CowUpdateModelRepositoryFromJson(json);
  Map<String, dynamic> toJson() => _$CowUpdateModelRepositoryToJson(this);
}
