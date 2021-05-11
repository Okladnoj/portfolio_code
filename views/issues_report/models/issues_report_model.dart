import 'dart:io';

class IssuesReportModel {
  final String stringNote;
  final List<File> voiceNotes;
  final List<File> attachments;

  IssuesReportModel(
    this.stringNote,
    this.voiceNotes,
    this.attachments,
  );

  IssuesReportModel copy({
    String stringNote,
    List<File> voiceNotes,
    List<File> attachments,
  }) {
    return IssuesReportModel(
      stringNote ?? this.stringNote,
      voiceNotes ?? this.voiceNotes,
      attachments ?? this.attachments,
    );
  }

  factory IssuesReportModel.empty() {
    return IssuesReportModel(
      '',
      [],
      [],
    );
  }
}
