/// Model class of donor user item to make private/public
/// value: item(for example: nickname in edit profile)
/// visible: private / public information
/// Author: Joyshree Chowdhury
/// All rights reserved .
class DonorUserItem {
  String value;
  bool visible;

  DonorUserItem({
    this.value,
    this.visible,
  });

  // Get donor user item from json format
  factory DonorUserItem.fromJson(dynamic d) {
    return DonorUserItem(
      value: d['value'],
      visible: d['visible'],
    );
  }

  // Make json from value
  Map<String, dynamic> toJson() => {
    'value': value,
    'visible': visible,
  };
}
