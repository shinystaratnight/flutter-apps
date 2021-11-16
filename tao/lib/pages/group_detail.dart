import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tao/cards/music_card.dart';
import 'package:tao/models/music_group.dart';

class GroupDetail extends StatefulWidget {
  final MusicGroup data;
  final String? tag;
  const GroupDetail({Key? key, required this.data, required this.tag})
      : super(key: key);

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: CustomScrollView(
        controller: controller,
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_backspace,
                color: Colors.white,
                size: 25,
              ),
              alignment: Alignment.topLeft,
              onPressed: () {
                // scaffoldKey.currentState!.openDrawer();
                Navigator.pop(context);
              },
            ),
            toolbarHeight: 300,
            // expandedHeight: MediaQuery.of(context).size.height * 0.20,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Hero(
                        tag: widget.tag!,
                        child: Image.asset(
                          widget.data.backgroundImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.6,
                      child: Container(
                        height: 300 - 90,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white,
                              Color(widget.data.backgroundColor!),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.data.title!,
                        style: TextStyle(
                            fontSize: 36,
                            fontFamily: 'assets/fonts/Titillium-Regular',
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        height: 120,
                        alignment: Alignment.center,
                        color: Color(widget.data.backgroundColor!),
                        child: Text(
                          widget.data.content!,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'assets/fonts/Titillium-Regular',
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: false,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              if (index < widget.data.musics!.length) {
                return MusicCard(
                  mg: widget.data,
                  d: widget.data.musics![index],
                  heroTag: 'musicbased$index',
                );
              }
            })),
          )
        ],
      ),
    );
  }
}
