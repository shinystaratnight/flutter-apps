import 'package:flutter/material.dart';
import 'package:fluttertest/screen/donor/charity_category.dart';
import 'package:fluttertest/screen/donor/next_screen.dart';

import 'charity_category_page.dart';

/// This page is to show all charity categories
/// Author: Joyshree Chowdhury
/// All rights reserved

class CategoriesMorePage extends StatefulWidget {
  CategoriesMorePage({Key key, this.charityCategories, this.userId})
      : super(key: key);
  final List<CharityCategory> charityCategories;
  final String userId;

  @override
  _CategoriesMorePageState createState() => _CategoriesMorePageState();
}

class _CategoriesMorePageState extends State<CategoriesMorePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Charity Categories'),
      ),
      body: _body(),
    );
  }

  // Design body with gridview widget
  _body() {
    return GridView.builder(
      controller: controller,
      padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.1),
      itemCount: widget.charityCategories.length,
      itemBuilder: (BuildContext context, int index) {
        return _CategoryItem(
          cc: widget.charityCategories[index],
          userId: widget.userId,
          index: index,
        );
      },
    );
  }
}

/// Charity category item class
/// Author: Joyshree Chowdhury
/// All rights reserved

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({Key key, this.cc, this.userId, this.index})
      : super(key: key);
  final CharityCategory cc;
  final String userId;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Go to cagegory page with category name
        nextScreen(context, CharityCategoryPage(cc: cc, userId: userId));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
                blurRadius: 10, offset: Offset(0, 3), color: Colors.pink[100]),
          ],
          image: DecorationImage(
            // image: NetworkImage(
            //     charityCategories[index].image),
            // scale: 1.0),
              image: AssetImage('assets/cat_$index.jpg'),
              fit: BoxFit.cover,
              scale: 1.0),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15, bottom: 15, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.pinkAccent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    cc.name,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
