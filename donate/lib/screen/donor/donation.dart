import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

/// Donation model class
/// Author: Joyshree Chowdhury
/// All rights reserved

class Donation {
  String userId;
  String name;
  String amount;
  String createdAt;
  String description;
  String category;
  String type;
  String docId;

  Donation({
    this.userId,
    this.name,
    this.amount,
    this.createdAt,
    this.description,
    this.category,
    this.type,
    this.docId,
  });

  factory Donation.fromJson(dynamic d) {
    Timestamp t = d['donatedAt'];
    String time = DateFormat('yyyy-MM-dd HH:mm').format(t.toDate());
    return Donation(
      userId: d['userId'],
      name: d['eventTitle'],
      amount: d['donation'],
      createdAt: time,
      description: '',
      category: '',
      type: '',
      docId: '',
    );
  }
}
