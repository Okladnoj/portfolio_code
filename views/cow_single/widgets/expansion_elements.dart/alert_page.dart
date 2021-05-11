part of 'expansion_element.dart';

class _ExpansionAlertPanelState extends State<CustomExpansionPanel> with SingleTickerProviderStateMixin {
  _ExpansionAlertPanelState();
  AlertsInteractor _alertsInteractor;
  AlertsModelUI _alertsModelUI;

  bool _isExpanded;
  bool _isLoading = true;
  final _duration = const Duration(milliseconds: 150);
  @override
  void initState() {
    _isExpanded = false;
    _alertsInteractor = AlertsInteractor();
    _alertsInteractor.loadAlertsDataByBolusId(widget.bolusId).then((value) => _isLoading = false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AlertsModelUI>(
        stream: _alertsInteractor.observer,
        builder: (context, snapshot) {
          _alertsModelUI = snapshot?.data ?? _alertsModelUI;

          return Container(
            decoration: DesignStile.buttonDecoration(
              borderRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
            child: AnimatedSize(
              alignment: const Alignment(0, -1),
              vsync: this,
              duration: _duration,
              curve: Curves.fastOutSlowIn,
              child: Column(
                children: [
                  _buildTitlePanel(),
                  ..._buildContent(),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildTitlePanel() {
    return InkCustomButton(
      height: 50,
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: const Alignment(0, 0),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Alert for this cow',
              style: DesignStile.textStyleCustom(
                fontWeight: FontWeight.w500,
                fontSize: 22,
                color: DesignStile.black,
              ),
            ),
            RotatedBox(
              quarterTurns: _isExpanded ? -45 : 45,
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 30,
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    final List<Widget> list = List.generate(_alertsModelUI?.listAlerts?.length ?? 0, (i) {
      final alert = _alertsModelUI?.listAlerts[i];
      return FullAlertCard(
        isInsideCow: true,
        alertModelUI: alert,
        cowSingleInteractor: widget.cowSingleInteractor,
        alertsInteractor: _alertsInteractor,
        eventsInteractor: widget.eventsInteractor,
      );
    });

    if (_isExpanded) {
      if (_isLoading) {
        return [_buildWhiter()];
      }
      if (list.isEmpty) {
        return [_buildNoAlerts()];
      }
      return list..add(const SizedBox(height: 20));
    } else {
      return [];
    }
  }

  Widget _buildNoAlerts() => Container(
      alignment: const Alignment(0, 0),
      height: 150,
      child: Text('No Alerts', style: DesignStile.textStyleCustom(fontSize: 16)));

  Widget _buildWhiter() =>
      SizedBox(height: 150, child: SafeText(null, style: DesignStile.textStyleCustom(fontSize: 80)));
}
