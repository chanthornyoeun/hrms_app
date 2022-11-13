import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? picture;
  final String gender;
  final EdgeInsets? padding;
  final double? size;

  const Avatar(
      {Key? key,
      required this.picture,
      required this.gender,
      this.padding,
      this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: padding,
          child: CircleAvatar(
            radius: size ?? 32,
            backgroundImage: picture != null
                ? NetworkImage(picture!)
                : AssetImage('assets/images/${gender.toLowerCase()}.png')
                    as ImageProvider,
          ),
        ),
      ],
    );
  }
}
