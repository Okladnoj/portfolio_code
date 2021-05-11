import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/components/formers/screen_former.dart';
import 'package:cattle_scan/components/text_field/text_form_multiline.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/alerts/widgets/title.dart';
import 'package:cattle_scan/views/issues_report/components/voice/voice_recorder.dart';
import 'package:flutter/material.dart';

import 'components/attachment/attachment_loader.dart.dart';
import 'issues_report_interactor.dart';
import 'models/issues_report_model_ui.dart';

class IssuesReportPage extends StatefulWidget {
  static const id = 'IssuesReportPage';

  const IssuesReportPage({Key key}) : super(key: key);

  @override
  _IssuesReportPageState createState() => _IssuesReportPageState();
}

class _IssuesReportPageState extends State<IssuesReportPage> {
  IssuesReportInteractor _issuesReportInteractor;
  IssuesReportModelUI _issuesReportModelUI;

  @override
  void initState() {
    _issuesReportInteractor = IssuesReportInteractor();
    super.initState();
  }

  @override
  void dispose() {
    _issuesReportInteractor?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFormer(
      titleActions: _buildTitleAlerts(),
      bottomButton: _buildButtonSendReport(),
      children: [
        _buildContent(),
      ],
    );
  }

  Widget _buildTitleAlerts() {
    return const TitleAlerts(nameTitle: 'Report Issues');
  }

  Widget _buildContent() {
    return StreamBuilder<IssuesReportModelUI>(
      stream: _issuesReportInteractor?.observer,
      builder: (context, snapshot) {
        _issuesReportModelUI = snapshot?.data ?? _issuesReportModelUI;

        return Column(
          children: [
            _buildTitleContent(),
            _buildTextNotes(),
            VoiceRecorder(issuesReportInteractor: _issuesReportInteractor),
            AttachmentLoader(issuesReportInteractor: _issuesReportInteractor),
            SizedBox(height: MediaQuery.of(context).size.height / 1.5),
          ],
        );
      },
    );
  }

  Widget _buildTextNotes() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormMultiLineDesign(
        labelText: 'Note',
        hintText: 'Note',
        maxLines: 7,
        onChanged: (stringNote) {
          _issuesReportInteractor?.onChangeStringNote(stringNote);
        },
      ),
    );
  }

  Widget _buildTitleContent() {
    return Container(
      alignment: const Alignment(0, 0),
      margin: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
      child: Text(
        'Issues / Comments / Concerns / Recommendation',
        textAlign: TextAlign.center,
        style: DesignStile.textStyleCustom(
          color: DesignStile.dark,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _buildButtonSendReport() {
    return StreamBuilder<IssuesReportModelUI>(
        stream: _issuesReportInteractor?.observer,
        builder: (context, snapshot) {
          _issuesReportModelUI = snapshot?.data ?? _issuesReportModelUI;
          final isSave = _issuesReportModelUI?.isFill ?? false;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: InkCustomButton(
              height: 50,
              onTap: () {
                AppNavigator.pop();

                if (isSave) {
                  _issuesReportInteractor.sendReport();
                }
              },
              child: Container(
                alignment: const Alignment(0, 0),
                decoration: DesignStile.buttonDecoration(
                  blurRadius: 10,
                  borderRadius: 10,
                  offset: const Offset(0, 2),
                  colorBoxShadow: isSave ? DesignStile.red : DesignStile.grey,
                  color: isSave ? DesignStile.primary : DesignStile.grey,
                ),
                child: Text(
                  'Send Report',
                  style: DesignStile.textStyleCustom(
                    fontSize: 24,
                    color: DesignStile.white,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
