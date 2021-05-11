part of 'voice_recorder.dart';

typedef _Fn = void Function();

/// Example app.
class SimpleRecorder extends StatefulWidget {
  final int recordIndex;
  const SimpleRecorder({
    Key key,
    @required this.recordIndex,
  }) : super(key: key);

  @override
  _SimpleRecorderState createState() => _SimpleRecorderState();
}

class _SimpleRecorderState extends State<SimpleRecorder> {
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  bool _isActivePlayStop = false;

  String _mPath;

  @override
  void initState() {
    _mPath = 'Record_N${widget.recordIndex ?? 0}.aac';
    _mPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _mPlayer.closeAudioSession();
    _mPlayer = null;

    _mRecorder.closeAudioSession();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder.openAudioSession();
    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() {
    _mRecorder
        .startRecorder(
      toFile: _mPath,
      //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder.stopRecorder().then((value) {
      setState(() {
        //var url = value;
        _mplaybackReady = true;
      });
    });
  }

  void play() {
    assert(
      _mPlayerIsInited &&
          _mplaybackReady &&
          _mRecorder.isStopped &&
          _mPlayer.isStopped,
    );
    _mPlayer
        .startPlayer(
            fromURI: _mPath,
            //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer.stopPlayer().then((value) {
      setState(() {});
    });
  }

// ----------------------------- UI --------------------------------------------

  _Fn getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer.isStopped) {
      return null;
    }

    return _mRecorder.isStopped ? record : stopRecorder;
  }

  _Fn getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder.isStopped) {
      _isActivePlayStop = false;
      return null;
    }
    _isActivePlayStop = true;
    return _mPlayer.isStopped ? play : stopPlayer;
  }

  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return Column(
        children: [
          _buildRecordListenPanel(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildButtonAddFile(false, 'Cancel')),
              const SizedBox(width: 10),
              Expanded(child: _buildButtonAddFile(true, 'Add Record')),
            ],
          ),
        ],
      );
    }

    return makeBody();
  }

  Container _buildRecordListenPanel() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder.isStopped) {
      _isActivePlayStop = false;
    } else {
      _isActivePlayStop = true;
    }
    const double size = 60;
    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.all(3),
      height: 150,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: DesignStile.buttonDecoration(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Text(
                'Record/Listen panel',
                style: DesignStile.textStyleCustom(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRecordButton(size),
              ..._buildListenButton(size),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecordButton(double size) {
    return InkCustomButton(
      height: size,
      width: size,
      borderRadius: BorderRadius.circular(size),
      onTap: getRecorderFn(),
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: DesignStile.primary,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: DesignStile.primary, blurRadius: 20)]),
        child: !_mRecorder.isRecording
            ? Icon(
                Icons.keyboard_voice_outlined,
                size: size / 1.5,
                color: DesignStile.white,
              )
            : Icon(
                Icons.stop_sharp,
                size: size / 1.5,
                color: DesignStile.white,
              ),
      ),
    );
  }

  List<Widget> _buildListenButton(double size) {
    return _isActivePlayStop
        ? [
            const SizedBox(width: 30),
            InkCustomButton(
              height: size,
              width: size,
              borderRadius: BorderRadius.circular(size),
              onTap: getPlaybackFn(),
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: DesignStile.blue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: DesignStile.blue, blurRadius: 20),
                  ],
                ),
                child: !_mPlayer.isPlaying
                    ? Icon(
                        Icons.play_arrow,
                        size: size / 1.5,
                        color: DesignStile.white,
                      )
                    : Icon(
                        Icons.pause,
                        size: size / 1.5,
                        color: DesignStile.white,
                      ),
              ),
            )
          ]
        : [];
  }

  Widget _buildButtonAddFile(bool isSave, String string) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkCustomButton(
        height: 50,
        onTap: () async {
          if (isSave) {
            AppNavigator.pop(await _mRecorder.getRecordURL(path: _mPath));
          } else {
            AppNavigator.pop();
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
            string,
            style: DesignStile.textStyleCustom(
              fontSize: 18,
              color: DesignStile.white,
            ),
          ),
        ),
      ),
    );
  }
}
