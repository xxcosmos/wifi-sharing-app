import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wifi_sharing_app/common/model/account.dart';
import 'package:wifi_sharing_app/common/utils/name_list.dart';
import '../common/utils/http.dart';

class WiFiBody extends StatefulWidget {
  _WiFiBodyState createState() => _WiFiBodyState();
}

class _WiFiBodyState extends State<WiFiBody> {
  String text = '';
  String buttonText = '连接';
  String username = "201713137012";
  String password = "1027";
  String url = "http://202.114.240.108:8080/zportal/";
  String result = '';

  Future<AccountList> accountList = decodeAccountList();

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
              // String url = "https://www.baidu.com";
              dio.get(url).then((res) {
                // 连接前提示
                setState(() {
                  text = "正在连接ing";
                });

                FormData formData =  FormData.from({
                  "qrCodeId": "请输入编号",
                  "username": username,
                  "pwd": password,
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
                  Map<String, dynamic> resultMap =
                      json.decode(res.data.toString());
                  if (resultMap['result'] == 'success'||resultMap['result']=='online') {
                    setState(() {
                      text = "连接成功";
                    });
                  } else if (resultMap['result'] == 'fail') {
                    accountList.then((value) {
                      int index = Random().nextInt(value.accountList.length);
                      debugPrint(value.accountList.length.toString());
                      Account account = value.accountList.elementAt(index);
                      debugPrint(account.toString());
                      setState(() {
                        if (account != null) {
                          username = account.username;
                          password = account.idNumber.substring(6, 14);
                        }
                        text = resultMap['message'] + '请换一个账号尝试';
                      });
                    });
                  }
                  setState(() {
                    result = res.data.toString();
                  });
                }).catchError((error) {
                  setState(() {
                    text = 'error' + error.toString();
                  });
                });
              }).catchError((e) {
                // 未连接校园网
                setState(() {
                  text = "请先连接 WUST_Wireless";
                });
              });
            },
          ),
          Text('tips: ' + text),
          Text('username: ' + username),
          Text('result: '+result),
        ],
      ),
    );
  }
}
