import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tao/models/music.dart';
import 'package:tao/models/music_group.dart';
import 'package:tao/pages/audio_play.dart';
import 'package:tao/pages/group_detail.dart';

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreeniOS(context, page) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
}

void nextScreenCloseOthers(context, page) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenPopup(context, page) {
  Navigator.push(
    context,
    MaterialPageRoute(fullscreenDialog: true, builder: (context) => page),
  );
}

void navigateToDetailsScreen(context, MusicGroup mg, String? heroTag) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => GroupDetail(
              data: mg,
              tag: heroTag,
            )),
  );
}

void navigateToPlayerScreen(
    context, MusicGroup mg, Music music, String? heroTag) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => AudioPlay(
              mg: mg,
              music: music,
              tag: heroTag,
            )),
  );
}
