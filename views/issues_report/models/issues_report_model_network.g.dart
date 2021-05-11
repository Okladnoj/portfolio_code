// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issues_report_model_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssuesReportModelNetwork _$IssuesReportModelNetworkFromJson(Map<String, dynamic> json) {
  return IssuesReportModelNetwork(
    json['string_note'] as String,
    (json['voice_notes'] as List)?.map((e) => e as File)?.toList(),
    (json['attachments'] as List)?.map((e) => e as File)?.toList(),
  );
}

Map<String, dynamic> _$IssuesReportModelNetworkToJson(IssuesReportModelNetwork instance) => <String, dynamic>{
      'string_note': instance.stringNote,
      'voice_notes': instance.voiceNotes,
      'attachments': instance.attachments,
    };
