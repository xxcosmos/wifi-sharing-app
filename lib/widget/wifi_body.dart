import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../common/utils/http.dart';

class WiFiBody extends StatefulWidget {
  _WiFiBodyState createState() => _WiFiBodyState();
}

class _WiFiBodyState extends State<WiFiBody> {
  String text = '';
  String buttonText = '连接';
//          onHighlightChanged: onHighlightChanged,
//          textTheme: textTheme,
//          clipBehavior: clipBehavior,
//          materialTapTargetSize: materialTapTargetSize,
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text(buttonText),
            textColor: Colors.white,
            padding: const EdgeInsets.all(8),
            color: Colors.blue,
            splashColor: Colors.white,
            shape: CircleBorder(),
            onPressed: () {
              String url = "http://202.114.240.108:8080/zportal/";
              // String url = "https://www.baidu.com";
              dio.get(url).then((res) {
                setState(() {
                  text = "正在连接ing";
                });

                FormData formData = new FormData.from({
                  "qrCodeId": "请输入编号",
                  "username": "201713137042",
                  "pwd": "10271027",
                  "validCode": "验证码",
                  "validCodeFlag": "false",
                  "ssid": "b8a9c2a1989e15776af70dbf182bbbe6",
                  "t": "wireless-v2-plain",
                  "wlanacname": "182b6ff913c0d9a508d195bca363a86f",
                  "nasip": "5340d13e4208e1b891476c890b7f5f5c",
                  "wlanuserip": "f09df0ee06255f08c28797b2f2383ef8",
                });
                dio
                    .post("http://202.114.240.108:8080/zportal/login/do",
                        data: formData)
                    .then((res) {
                  setState(() {
                    text = res.data.toString();
                  });
                }).catchError((error) {
                  setState(() {
                    text = error.toString();
                  });
                });
              }).catchError((e) {
                setState(() {
                  text = "请先连接 WUST_Wireless";
                });
              });
            },
          ),
          Text(text),
        ],
      ),
    );
  }
}
