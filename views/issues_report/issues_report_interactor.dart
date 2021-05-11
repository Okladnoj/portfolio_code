import 'dart:async';
import 'dart:io';

import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/settings/constants.dart';

import 'domain/issues_report_repository.dart';
import 'models/issues_report_model.dart';
import 'models/issues_report_model_ui.dart';

class IssuesReportInteractor {
  IssuesReportInteractor() {
    _init();
  }

  final StreamController<IssuesReportModelUI> _controller = StreamController.broadcast();
  StreamSink<IssuesReportModelUI> get sink => _controller.sink;
  Stream<IssuesReportModelUI> get observer => _controller.stream;

  IssuesReportModel _issuesReportModel;
  IssuesReportRepository _issuesReportRepository;

  void dispose() {
    _controller.close();
  }

  Future<void> sendReport() async {
    final isSave = await _issuesReportRepository.sendReport(_issuesReportModel);
    if (isSave) {
      AppNavigator.showSnackBar('Successful send Report', colorText: DesignStile.green);
    } else {
      AppNavigator.showSnackBar('Not send Report');
    }
  }

  void _init() {
    _issuesReportRepository = IssuesReportRepository();
    _loadSettings();
  }

  Future _loadSettings() async {
    _issuesReportModel = IssuesReportModel.empty();
    _updateUI();
  }

  void onChangeStringNote(String stringNote) {
    _issuesReportModel = _issuesReportModel.copy(stringNote: stringNote);
    _updateUI();
  }

  void onAddStringsVoice(String pathVoice) {
    final file = File.fromUri(Uri.parse(pathVoice));
    _issuesReportModel.voiceNotes.add(file);
    _updateUI();
  }

  void onRemoveStringsVoice(File file) {
    _issuesReportModel.voiceNotes.remove(file);
    _updateUI();
  }

  void onAddFileAttachments(List<File> files) {
    for (final file in files) {
      _issuesReportModel.attachments.add(file);
    }
    _updateUI();
  }

  void onRemoveFileAttachments(File file) {
    _issuesReportModel.attachments.remove(file);
    _updateUI();
  }

  void _updateUI() {
    sink.add(_mapToUI());
  }

  IssuesReportModelUI _mapToUI() {
    return IssuesReportModelUI(
      _issuesReportModel?.stringNote,
      _issuesReportModel?.voiceNotes,
      _issuesReportModel?.attachments,
    );
  }
}
