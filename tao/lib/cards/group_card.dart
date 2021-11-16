import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tao/models/music_group.dart';
import 'package:tao/utils/asset_image.dart';
import 'package:tao/utils/cached_image.dart';
import 'package:tao/utils/next_screen.dart';

class GroupCard extends StatelessWidget {
  final MusicGroup d;
  final String heroTag;
  const GroupCard({Key? key, required this.d, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color: Color(d.backgroundColor!),
            // color: d.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 10,
                  offset: Offset(0, 3))
            ]),
        child: Wrap(
          children: [
            Hero(
              tag: heroTag,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    child: AssetedImage(
                      image: d.backgroundImage!,
                      radius: 10,
                      circularShape: false,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        d.title!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      Spacer(),
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          new CircularPercentIndicator(
                            radius: 60,
                            lineWidth: 2,
                            percent: d.playedMusics! / d.totalMusic!,
                            progressColor: Color(0xffF6BE4F),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                d.playedMusics.toString(),
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                              Text(
                                '----------',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                              Text(
                                d.totalMusic.toString(),
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () => navigateToDetailsScreen(context, d, heroTag),
    );
  }
}
