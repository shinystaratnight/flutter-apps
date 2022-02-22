import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertest/screen/donor/donor_user.dart';
import 'package:fluttertest/screen/donor/donor_user_item.dart';

/// This is provider for donor user
/// description: get donor user information from firebase using provider
/// Author: Joyshree Chowdhury
/// All rights reserved
class DonorUserBloc extends ChangeNotifier {
  var firestoreInstance = FirebaseFirestore.instance;
  bool isFind = false;

  DonorUser donorUser;
  Future getDonorUser(uid) async {
    var a = await firestoreInstance.collection('DonorUser').get();
    for (dynamic element in a.docs) {
      if (element.data()['uid'] == uid) {
        donorUser = DonorUser(
          uid: element.data()['uid'],
          avatar: element.data()['avatar'],
          password: element.data()['password'],
          nickname: getDonorUserItem(element.data()['nickname']),
          name: getDonorUserItem(element.data()['name']),
          email: getDonorUserItem(element.data()['email']),
          phone: getDonorUserItem(element.data()['phone']),
          address: getDonorUserItem(element.data()['address']),
        );
        isFind = true;
        break;
      }
    }

    notifyListeners();
  }

  getDonorUserItem(dynamic d) {
    DonorUserItem dui = DonorUserItem();
    dui.value = d['value'];
    dui.visible = d['visible'];

    return dui;
  }
}
