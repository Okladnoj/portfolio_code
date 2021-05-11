// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cow_update_model_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CowUpdateModelRepository _$CowUpdateModelRepositoryFromJson(
    Map<String, dynamic> json) {
  return CowUpdateModelRepository(
    json['animal_id'] as int,
    json['lactation_stage'] as String,
    json['date_lactation_start'] as String,
  );
}

Map<String, dynamic> _$CowUpdateModelRepositoryToJson(
        CowUpdateModelRepository instance) =>
    <String, dynamic>{
      'animal_id': instance.animalId,
      'lactation_stage': instance.lactationStage,
      'date_lactation_start': instance.dateLactationStart,
    };
