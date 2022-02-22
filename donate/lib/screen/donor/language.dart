import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertest/screen/donor/config.dart';

/// Select language screen from multiple language list
/// Author: Joyshree Chowdhury
/// All rights reserved

class LanguagePopup extends StatefulWidget {
  const LanguagePopup({Key key}) : super(key: key);

  @override
  _LanguagePopupState createState() => _LanguagePopupState();
}

class _LanguagePopupState extends State<LanguagePopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select language').tr(),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: Config().languages.length,
        itemBuilder: (BuildContext context, int index) {
          return _itemList(Config().languages[index], index);
        },
      ),
    );
  }

  Widget _itemList(d, index) {
    // Language list(english , french , japanese and arabic)
    return Column(
      children: [
        ListTile(
          // Icon, title, Tab listener
          leading: Icon(Icons.language),
          title: Text(d),
          onTap: () async {
            if (d == 'English') {
              context.setLocale(Locale('en'));
            } else if (d == 'French') {
              context.setLocale(Locale('fr'));
            } else if (d == 'Arabic') {
              // Arabic
              context.setLocale(Locale('ar'));
            } else if (d == 'Japanese') {
              // Japansese
              context.setLocale(Locale('ja'));
            }
            Navigator.pop(context);
          },
        ),
        Divider(
          height: 3,
          color: Colors.grey[400],
        )
      ],
    );
  }
}
