import 'package:flutter/material.dart';
import 'package:swash/models/models.dart';
import '../object/who_view_or_like.dart';

class PostButton extends StatefulWidget {
  final String postID;
  final Views views;
  final String name;
  final Function? turn;

  const PostButton(
      {Key? key,
      required this.postID,
      required this.views,
      required this.name,
      this.turn})
      : super(key: key);

  @override
  _PostButtonState createState() => _PostButtonState();
}

class _PostButtonState extends State<PostButton> {
  bool _selected = false;
  late Future<Views> _views;
  final Map<String, Widget> _buttons = {
    'like': const Icon(Icons.favorite_border_outlined),
    'views': const Icon(Icons.visibility_outlined),
    'comment': const Icon(Icons.comment_outlined)
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            color:
                _selected ? Colors.black12 : Theme.of(context).iconTheme.color,
            onPressed: () {
              switch (widget.name) {
                case "like":
                  setState(() {
                    _selected = !_selected;
                    if (_selected) {
                      whoViewOrlike(widget.postID, -1, 0, 0);
                    } else {
                      whoViewOrlike(widget.postID, 1, 0, 0);
                    }
                  });

                  break;
                case "comment":
                  widget.turn!();

                  break;
              }
            },
            icon: _buttons[widget.name]!),
        const SizedBox(
          width: 8,
        ),
        Text('${getValue(widget.name)}')
      ],
    );
  }

  int getValue(String name) {
    if (name == 'like') {
      return widget.views.likes;
    } else {
      return widget.views.comments;
    }
  }
}
