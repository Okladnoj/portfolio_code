import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'issues_report_model_network.g.dart';

@JsonSerializable()
class IssuesReportModelNetwork {
  @JsonKey(name: "string_note")
  final String stringNote;
  @JsonKey(name: "voice_notes")
  final List<File> voiceNotes;
  @JsonKey(name: "attachments")
  final List<File> attachments;

  IssuesReportModelNetwork(
    this.stringNote,
    this.voiceNotes,
    this.attachments,
  );

  factory IssuesReportModelNetwork.fromJson(Map<String, dynamic> json) {
    return _$IssuesReportModelNetworkFromJson(json);
  }
  Map<String, dynamic> toJson() => _$IssuesReportModelNetworkToJson(this);
}
