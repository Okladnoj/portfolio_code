import 'package:freezed_annotation/freezed_annotation.dart';

part 'cow_add_model_network.g.dart';

@JsonSerializable()
class CowAddModelNetwork {
  @JsonKey(name: "bolus_id")
  final int bolusId;
  @JsonKey(name: "animal_id")
  final int animalId;
  @JsonKey(name: "date_of_birth")
  final String dateOfBirth;
  @JsonKey(name: "lactation_number")
  final int lactationNumber;
  @JsonKey(name: "lactation_stage")
  final String lactationStage;
  @JsonKey(name: "date_lactation_start")
  final String dateLactationStart;

  CowAddModelNetwork(
    this.bolusId,
    this.animalId,
    this.dateOfBirth,
    this.lactationNumber,
    this.lactationStage,
    this.dateLactationStart,
  );

  factory CowAddModelNetwork.fromJson(Map<String, dynamic> json) => _$CowAddModelNetworkFromJson(json);
  Map<String, dynamic> toJson() => _$CowAddModelNetworkToJson(this);
}
