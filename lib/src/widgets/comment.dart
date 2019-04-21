import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/item_model.dart';
import 'loading_container.dart';

class Comment extends StatelessWidget {

  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;


  Comment({this.itemId, this.itemMap, this.depth});


  Widget build(context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        final item = snapshot.data;
        final children = <Widget>[
          ListTile(
            title: buildText(item),
            subtitle: item.by == '' ? Text('[deleted]') : Text(item.by),
            contentPadding: EdgeInsets.only(
              right: 16.0,
              left: 16.0 * depth,
            ),
          ),
          Divider(),
        ];

        item.kids.forEach((kidId) {
          children.add(
            Comment(
              itemId: kidId,
              itemMap: itemMap,
              depth: depth + 1
            ),
          );
        });

        return Column(
          children: children
        );
      },
    );
  }


  buildText(ItemModel item) {
    return Html(
      data: item.text,
      onLinkTap: (url) async {
        await launch('$url');
      }
    );
  }
}