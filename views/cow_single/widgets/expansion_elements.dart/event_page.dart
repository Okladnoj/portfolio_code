part of 'expansion_element.dart';

class _ExpansionEventPanelState extends State<CustomExpansionPanel> with SingleTickerProviderStateMixin {
  _ExpansionEventPanelState(this._eventsInteractor);
  final EventsInteractor _eventsInteractor;
  EventsModelUI _eventsModelUI;

  bool _isExpanded;
  bool _isLoading = true;
  final _duration = const Duration(milliseconds: 150);
  @override
  void initState() {
    _isExpanded = false;
    _eventsInteractor.loadEventsModel().then((value) => _isLoading = false);
    super.initState();
  }

  @override
  void dispose() {
    _eventsInteractor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EventsModelUI>(
        stream: _eventsInteractor.observer,
        builder: (context, snapshot) {
          _eventsModelUI = snapshot?.data ?? _eventsModelUI;

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
              'Event for this cow',
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
    final List<Widget> list = List.generate(_eventsModelUI?.events?.length ?? 0, (i) {
      AlertModelUI alertModelUI;
      EventModelUI eventModelUI;
      try {
        eventModelUI = _eventsModelUI?.events[i];
      } catch (e) {
        print(e);
      }

      try {
        alertModelUI = _eventsModelUI?.eventsFull[i]?.alerts?.first;
      } catch (e) {
        print(e);
      }

      return FullEventCard(
        eventModelUI: eventModelUI,
        isInsideCow: true,
        alertModelUI: alertModelUI,
      );
    });

    if (_isExpanded) {
      if (_isLoading) {
        return [_buildWhiter()];
      }
      if (list.isEmpty) {
        return [_buildNoEvents()];
      }
      return list..add(const SizedBox(height: 20));
    } else {
      return [];
    }
  }

  Widget _buildNoEvents() => Container(
      alignment: const Alignment(0, 0),
      height: 150,
      child: Text('No Events', style: DesignStile.textStyleCustom(fontSize: 16)));

  Widget _buildWhiter() =>
      SizedBox(height: 150, child: SafeText(null, style: DesignStile.textStyleCustom(fontSize: 80)));
}
