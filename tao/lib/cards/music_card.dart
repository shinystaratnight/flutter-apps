import 'package:flutter/material.dart';
import 'package:tao/models/music.dart';
import 'package:tao/models/music_group.dart';
import 'package:tao/utils/next_screen.dart';

class MusicCard extends StatelessWidget {
  final MusicGroup mg;
  final Music d;
  final String heroTag;

  const MusicCard(
      {Key? key, required this.mg, required this.d, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: const Color(0xffE2E2E2),
          borderRadius: BorderRadius.circular(5),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Theme.of(context).shadowColor,
                blurRadius: 10,
                offset: Offset(0, 3))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.headphones,
                color: Colors.black,
                size: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  d.name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.0),
                  maxLines: 2,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                d.length.toString() + '’',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        navigateToPlayerScreen(context, mg, d, heroTag);
      },
    );
  }
}
