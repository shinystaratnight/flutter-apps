import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:tao/config/config.dart';
import 'package:tao/manager/audio_manager.dart';
import 'package:tao/models/music.dart';
import 'package:tao/models/music_group.dart';

class AudioPlay extends StatefulWidget {
  final MusicGroup mg;
  final Music? music;
  final String? tag;
  const AudioPlay(
      {Key? key, required this.mg, required this.music, required this.tag})
      : super(key: key);

  @override
  _AudioPlayState createState() => _AudioPlayState();
}

class _AudioPlayState extends State<AudioPlay> {
  late final AudioManager _audioManager;

  popupNavigator() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    // convert google drive url
    List<String> items = widget.music!.url!.split('/');
    var id = items[items.length - 2];
    String convertUrl = 'https://drive.google.com/uc?export=view&id=$id';
    _audioManager = AudioManager(convertUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _audioManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 20.0,
                sigmaY: 20.0,
              ),
              child: Image(
                image: AssetImage(widget.mg.backgroundImage!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 10,
              top: 30,
              right: 10,
              bottom: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        popupNavigator();
                      },
                      icon: Icon(
                        Icons.keyboard_backspace,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
                Container(
                  width: 300,
                  height: 300,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment(0.8, -1),
                        child: CircleAvatar(
                          radius: 120,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.8, 1),
                        child: CircleAvatar(
                          radius: 120,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                      Align(
                        alignment: Alignment(-1.5, 0.2),
                        child: CircleAvatar(
                          radius: 120,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 130,
                          backgroundImage:
                              AssetImage(widget.mg.backgroundImage!),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.music!.name!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Config().titilliumFont,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: IconButton(
                        onPressed: _audioManager.rewind,
                        icon: Icon(
                          Icons.fast_rewind,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    ValueListenableBuilder<ButtonState>(
                      valueListenable: _audioManager.buttonNotifier,
                      builder: (_, value, __) {
                        switch (value) {
                          case ButtonState.loading:
                            return SizedBox(
                              height: 80,
                              width: 80,
                              child: Container(
                                margin: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          case ButtonState.paused:
                            return SizedBox(
                              height: 80,
                              width: 80,
                              child: IconButton(
                                onPressed: _audioManager.play,
                                alignment: Alignment.center,
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                            );
                          case ButtonState.playing:
                            return SizedBox(
                              height: 80,
                              width: 80,
                              child: IconButton(
                                onPressed: _audioManager.pause,
                                alignment: Alignment.center,
                                icon: Icon(
                                  Icons.pause,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                            );
                        }
                      },
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: IconButton(
                        onPressed: _audioManager.forward,
                        icon: Icon(
                          Icons.fast_forward,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
                ValueListenableBuilder<ProgressBarState>(
                  valueListenable: _audioManager.progressNotifier,
                  builder: (_, value, __) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ProgressBar(
                        progress: value.current,
                        buffered: value.buffered,
                        total: value.total,
                        onSeek: _audioManager.seek,
                        progressBarColor: Colors.white,
                        thumbColor: Colors.white,
                        baseBarColor: Colors.white38,
                        bufferedBarColor: Colors.white24,
                        barHeight: 3,
                        timeLabelLocation: TimeLabelLocation.sides,
                        timeLabelTextStyle: TextStyle(
                          fontFamily: Config().titilliumFont,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
