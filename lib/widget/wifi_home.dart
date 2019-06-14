import 'package:flutter/material.dart';
import 'package:wifi_sharing_app/widget/wifi_body.dart';

class WiFiHome extends StatefulWidget {
  _WiFiHomeState createState() => _WiFiHomeState();
}

class _WiFiHomeState extends State<WiFiHome> {
  final topBar = AppBar(
    backgroundColor: Colors.blue,
    centerTitle: true,
    elevation: 1.0,
    // leading: Icon(Icons.camera_alt),
    title: SizedBox(
      height: 35.0,
      child: Text(
        "连接校园网",
        style: TextStyle(color: Colors.white),
      ),
    ),
    // actions: <Widget>[
    //   Padding(
    //     padding: const EdgeInsets.only(right: 12.0),
    //     child: Icon(Icons.send),
    //   )
    // ],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar,
      body: WiFiBody(),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 50,
        alignment: Alignment.center,
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.account_box),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
