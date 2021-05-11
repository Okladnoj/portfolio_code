// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cow_add_model_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CowAddModelNetwork _$CowAddModelNetworkFromJson(Map<String, dynamic> json) {
  return CowAddModelNetwork(
    json['bolus_id'] as int,
    json['animal_id'] as int,
    json['date_of_birth'] as String,
    json['lactation_number'] as int,
    json['lactation_stage'] as String,
    json['date_lactation_start'] as String,
  );
}

Map<String, dynamic> _$CowAddModelNetworkToJson(CowAddModelNetwork instance) =>
    <String, dynamic>{
      'bolus_id': instance.bolusId,
      'animal_id': instance.animalId,
      'date_of_birth': instance.dateOfBirth,
      'lactation_number': instance.lactationNumber,
      'lactation_stage': instance.lactationStage,
      'date_lactation_start': instance.dateLactationStart,
    };
