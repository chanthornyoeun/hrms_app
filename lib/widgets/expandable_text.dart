import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText({Key? key, required this.text}) : super(key: key);

  final String text;
  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          child: Text(
            widget.text,
            softWrap: true,
            overflow: widget.isExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
            maxLines: widget.isExpanded ? null : 3,
          ),
        ),
        if (widget.text.length > 100)
          TextButton(
            child: Text(widget.isExpanded ? 'See less' : 'See more'),
            onPressed: () =>
                setState(() => widget.isExpanded = !widget.isExpanded),
          ),
      ],
    );
  }
}
