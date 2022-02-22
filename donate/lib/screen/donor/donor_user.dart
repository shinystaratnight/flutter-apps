import 'donor_user_item.dart';

/// Model class of donor account
/// name, nickname, email, password, phone, address, profile image, uid
/// Author: Joyshree Chowdhury
/// All rights reserved
class DonorUser {
  String uid;
  DonorUserItem nickname; // nick name
  DonorUserItem name; // name
  DonorUserItem email; // email
  String password;
  String avatar;
  DonorUserItem phone; // phone number
  DonorUserItem address; // address

  DonorUser(
      {this.uid,
      this.nickname,
      this.name,
      this.email,
      this.password,
      this.avatar,
      this.phone,
      this.address});
}
