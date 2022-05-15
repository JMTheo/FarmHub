import 'package:flutter/material.dart';

class MiniCard extends StatelessWidget {
  MiniCard({required this.content, this.onTap});

  final dynamic content;
  final VoidCallback? onTap;

  _mudarConteudo() {
    if (content is String) {
      return Center(
        child: Text(
          content,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
    return IconButton(
        icon: Icon(
          content,
          color: Colors.white54,
        ),
        iconSize: 16.0,
        onPressed: onTap);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white30, style: BorderStyle.solid),
        ),
        child: _mudarConteudo());
  }
}
