import 'package:flutter/material.dart';

class AssetedImage extends StatelessWidget {
  final String? image;
  final double radius;
  final bool? circularShape;

  const AssetedImage(
      {Key? key,
      required this.image,
      required this.radius,
      required this.circularShape})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
          bottomLeft: Radius.circular(circularShape == false ? 0 : radius),
          bottomRight: Radius.circular(circularShape == false ? 0 : radius)),
      child: Image.asset(
        image!,
        fit: BoxFit.cover,
      ),
    );
  }
}
