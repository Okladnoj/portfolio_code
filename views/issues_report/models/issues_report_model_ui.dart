import 'dart:io';

class IssuesReportModelUI {
  final String stringNote;
  final List<File> voiceNotes;
  final List<File> attachments;

  IssuesReportModelUI(
    this.stringNote,
    this.voiceNotes,
    this.attachments,
  );

  bool get isFill =>
      (stringNote?.isNotEmpty ?? false) || //
      (voiceNotes?.isNotEmpty ?? false) ||
      (attachments?.isNotEmpty ?? false);
}
