import 'package:tao/models/music.dart';

class MusicGroup {
  String? title;
  String? backgroundImage;
  String? content;
  int? totalMusic;
  int? playedMusics;
  int? backgroundColor;
  List<Music>? musics;

  MusicGroup({
    this.title,
    this.backgroundImage,
    this.content,
    this.totalMusic,
    this.playedMusics,
    this.backgroundColor,
    this.musics,
  });

// MusicGroup.fromJson(Map<dynamic, dynamic> json)
//     : date = DateTime.parse(json['date'] as String),
//       text = json['text'] as String;

// Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
//       'date': date.toString(),
//       'text': text,
//     };
}
