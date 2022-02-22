/// Model class for charity item(Temp)
/// Author: Joyshree Chowdhury
/// All rights reserved
class CharityItem {
  String id;
  int categoryId;
  String image;
  String title;
  String content;
  bool favorite;
  int type;

  CharityItem(
      {this.id,
      this.categoryId,
      this.image,
      this.title,
      this.content,
      this.favorite,
      this.type});
}
