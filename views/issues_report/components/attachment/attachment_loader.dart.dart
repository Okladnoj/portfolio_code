import 'dart:io';

import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../issues_report_interactor.dart';
import '../../models/issues_report_model_ui.dart';

class AttachmentLoader extends StatefulWidget {
  final IssuesReportInteractor issuesReportInteractor;

  const AttachmentLoader({
    Key key,
    @required this.issuesReportInteractor,
  }) : super(key: key);
  @override
  _AttachmentLoaderState createState() => _AttachmentLoaderState();
}

class _AttachmentLoaderState extends State<AttachmentLoader> {
  IssuesReportModelUI _issuesReportModelUI;
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
          final FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true);
          if (result != null) {
            final List<File> files = result.paths.map((path) => File(path)).toList();
            widget.issuesReportInteractor?.onAddFileAttachments(files);
          } else {
            // User canceled the picker
          }
        },
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(
              Icons.attach_file,
              color: DesignStile.white,
            ),
            const SizedBox(width: 5),
            Text(
              'Attachments',
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
    return List.generate(_issuesReportModelUI?.attachments?.length ?? 0, (i) {
      final pathAttachment = _issuesReportModelUI?.attachments[i];
      final name = pathAttachment?.path?.split('/')?.last;
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
              name ?? 'Attachment ${i + 1}',
              style: DesignStile.textStyleCustom(
                color: DesignStile.dark,
              ),
            ),
            InkCustomButton(
              height: 30,
              width: 30,
              onTap: () {
                widget.issuesReportInteractor.onRemoveFileAttachments(pathAttachment);
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
