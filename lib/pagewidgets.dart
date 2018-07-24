import 'package:flutter/material.dart';

import 'db.dart';
import 'objects.dart';
import 'defs.dart';

class ResponsePage extends StatelessWidget {
  String response_id;
  Map db;

  String msg1 = "Your response for ";

  ResponsePage({Key key,
    @required this.response_id,
    this.db}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Response designated_resp = read_db(
        response_id, "responses/", db: this.db);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(msg1 + designated_resp.speaker),
      ),
      body: Container(
        padding: EdgeInsets.all(inset1),
        child: ListView(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}