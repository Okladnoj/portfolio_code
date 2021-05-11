import 'package:cattle_scan/api/api.dart';

import '../models/issues_report_model.dart';
import '../models/issues_report_model_network.dart';

class IssuesReportRepository {
  Future<bool> sendReport(IssuesReportModel m) async {
    final IssuesReportModelNetwork r = _mapToIssuesReportModelNetwork(m);
    _postVoiceNotes(r);
    _postAttachments(r);
    return _postNotes(r);
  }

  Future<bool> _postNotes(IssuesReportModelNetwork r) async {
    bool isUpdate = false;
    final postData = {'string_note': r.stringNote};
    final responseData = await CallApi.parsData(
      'sendNote',
      postData,
    );
    if (responseData != null) {
      isUpdate = true;
    }
    return isUpdate;
  }

  Future<bool> _postVoiceNotes(IssuesReportModelNetwork r) async {
    bool isUpdate = false;
    final responseData = await CallApi.postMultipart('sendVoiceNotes', r.voiceNotes);
    if (responseData != null) {
      isUpdate = true;
    }
    return isUpdate;
  }

  Future<bool> _postAttachments(IssuesReportModelNetwork r) async {
    bool isUpdate = false;
    final responseData = await CallApi.postMultipart('sendAttachments', r.attachments);
    if (responseData != null) {
      isUpdate = true;
    }
    return isUpdate;
  }

  IssuesReportModelNetwork _mapToIssuesReportModelNetwork(IssuesReportModel m) {
    return IssuesReportModelNetwork(
      m?.stringNote,
      m?.voiceNotes,
      m?.attachments,
    );
  }
}
