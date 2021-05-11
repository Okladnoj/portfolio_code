import 'package:flutter/material.dart';

import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/settings/constants.dart';

import '../interactor_cows_list.dart';
import '../models/cows_list_ui.dart';

class FilterAlert extends StatefulWidget {
  const FilterAlert({
    Key key,
    @required this.cowsListInteractor,
    @required this.cowsListModelUI,
  }) : super(key: key);

  final CowsListInteractor cowsListInteractor;
  final CowsListModelUI cowsListModelUI;

  @override
  _FilterAlertState createState() => _FilterAlertState();
}

class _FilterAlertState extends State<FilterAlert> {
  final double height = 500;
  CowsListModelUI _cowsListModelUI;

  @override
  void initState() {
    _cowsListModelUI = widget.cowsListModelUI;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CowsListModelUI>(
      stream: widget.cowsListInteractor.observer,
      builder: (context, snapshot) {
        _cowsListModelUI = snapshot?.data ?? _cowsListModelUI;
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: (MediaQuery.of(context).size.height - height) / 2,
          ),
          padding: const EdgeInsets.all(5),
          height: height,
          width: double.infinity,
          decoration: DesignStile.buttonDecoration(),
          child: Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Filter cows',
                  style: DesignStile.textStyleCustom(
                    fontSize: 24,
                  ),
                ),
                _buildButtonAcceptFilter(
                  _cowsListModelUI.showUnRead,
                  const Icon(
                    Icons.email,
                    color: DesignStile.primary,
                  ),
                  'Show cows with unread Alerts',
                  () {
                    widget.cowsListInteractor.changeShowUnRead(!_cowsListModelUI.showUnRead);
                  },
                ),
                _buildButtonAcceptFilter(
                  _cowsListModelUI.showRead,
                  const Icon(
                    Icons.drafts,
                    color: DesignStile.dark,
                  ),
                  'Show cows with read Alerts',
                  () {
                    widget.cowsListInteractor.changeShowRead(!_cowsListModelUI.showRead);
                  },
                ),
                _buildButtonsShowStages(true),
                _buildButtonsShowStages(false),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonAcceptFilter(bool isAccept, Icon icon, String title, void Function() onTap) {
    Color color;
    if (isAccept) {
      color = DesignStile.green;
    } else {
      color = DesignStile.primary;
    }
    return Row(
      children: [
        icon,
        const SizedBox(width: 10),
        Expanded(
          child: InkCustomButton(
            height: 50,
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: DesignStile.buttonDecoration(
                offset: const Offset(0, 1),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: color,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      isAccept ? Icons.check : Icons.close,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: DesignStile.textStyleCustom(
                      color: DesignStile.dark,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsShowStages(bool isStages) {
    final currentList = isStages ? kShowStages : kShowGroups;
    final List<Widget> children = List.generate(currentList.length, (i) {
      final s = currentList[i];
      bool isAccept;

      if (isStages) {
        isAccept = _cowsListModelUI?.showStages?.contains(s) ?? false;
      } else {
        isAccept = _cowsListModelUI?.showGroups?.contains(s) ?? false;
      }
      Color color;
      if (isAccept) {
        color = DesignStile.green;
      } else {
        color = DesignStile.primary;
      }
      return InkCustomButton(
        height: 35,
        width: 80,
        onTap: () {
          if (isStages) {
            widget.cowsListInteractor.changeShowStages(s as String);
          } else {
            widget.cowsListInteractor.changeShowGroups(s as int);
          }
        },
        child: Container(
          decoration: DesignStile.buttonDecoration(
            offset: const Offset(0, 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: color,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  isAccept ? Icons.check : Icons.close,
                  color: color,
                  size: 14,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                s.toString(),
                style: DesignStile.textStyleCustom(
                  color: DesignStile.dark,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    });
    return Container(
      height: 110,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: DesignStile.buttonDecoration(
        offset: const Offset(0, 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            isStages ? 'Stages' : 'Groups',
            style: DesignStile.textStyleCustom(
              color: DesignStile.dark,
              fontSize: 16,
            ),
          ),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: children,
          )
        ],
      ),
    );
  }
}
