import 'package:cattle_scan/app/app_navigator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../issues_report_interactor.dart';
import '../../models/issues_report_model_ui.dart';

part 'simple_recorder.dart';

class VoiceRecorder extends StatefulWidget {
  final IssuesReportInteractor issuesReportInteractor;

  const VoiceRecorder({
    Key key,
    @required this.issuesReportInteractor,
  }) : super(key: key);
  @override
  _VoiceRecorderState createState() => _VoiceRecorderState();
}

class _VoiceRecorderState extends State<VoiceRecorder> {
  IssuesReportModelUI _issuesReportModelUI;
  int recordIndex;
  @override
  void initState() {
    print('initVoiceRecorder');
    recordIndex = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<IssuesReportModelUI>(
        stream: widget.issuesReportInteractor?.observer,
        builder: (context, snapshot) {
          _issuesReportModelUI = snapshot?.data ?? _issuesReportModelUI;
          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildRecordButton(),
              ..._buildListRecords(),
            ],
          );
        });
  }

  Widget _buildRecordButton() {
    return Container(
      height: 50,
      alignment: const Alignment(0, 0),
      margin: const EdgeInsets.only(top: 30, left: 15, right: 15),
      decoration: DesignStile.buttonDecoration(
        color: DesignStile.primary,
        colorBorder: DesignStile.primary,
        offset: const Offset(0, 1),
      ),
      child: InkCustomButton(
        onTap: () async {
          final pathVoice = await AppNavigator.dialog<String>(Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            margin: const EdgeInsets.only(left: 10, right: 10, top: 250, bottom: 20),
            height: 350,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SimpleRecorder(
                recordIndex: recordIndex,
              ),
            ),
          ));
          if (pathVoice?.isNotEmpty ?? false) {
            recordIndex++;
            widget.issuesReportInteractor.onAddStringsVoice(pathVoice);
          }
        },
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(
              Icons.record_voice_over_outlined,
              color: DesignStile.white,
            ),
            const SizedBox(width: 5),
            Text(
              'Press to record',
              style: DesignStile.textStyleCustom(
                fontSize: 16,
                color: DesignStile.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildListRecords() {
    return List.generate(_issuesReportModelUI?.voiceNotes?.length ?? 0, (i) {
      final pathVoice = _issuesReportModelUI?.voiceNotes[i];
      final name = pathVoice?.path?.split('/')?.last;
      return Container(
        height: 35,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        padding: const EdgeInsets.only(left: 10, right: 2.5),
        decoration: DesignStile.buttonDecoration(
          borderRadius: 20,
          offset: const Offset(0, 1),
          color: DesignStile.disable,
          colorBorder: DesignStile.disable,
        ),
        alignment: const Alignment(0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name ?? 'Recording ${i + 1}',
              style: DesignStile.textStyleCustom(
                color: DesignStile.dark,
              ),
            ),
            InkCustomButton(
              height: 30,
              width: 30,
              onTap: () {
                widget.issuesReportInteractor.onRemoveStringsVoice(pathVoice);
              },
              child: Container(
                decoration: DesignStile.buttonDecoration(
                  borderRadius: 20,
                  offset: const Offset(0, 1),
                  color: DesignStile.grey,
                  colorBorder: DesignStile.grey,
                ),
                child: Icon(
                  Icons.close,
                  color: DesignStile.disable,
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
//_issuesReportModelUI?.voiceNotes?.map((e) => Text(e))?.toList() ?? [];
