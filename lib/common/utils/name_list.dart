import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:wifi_sharing_app/common/model/account.dart';

Future<String> _loadAccountJson() async{
  return await rootBundle.loadString('lib/assets/namelist.json');
}

Future<AccountList> decodeAccountList() async{
  String accountListJson =  await _loadAccountJson();

  List<dynamic> list = json.decode(accountListJson);

  AccountList accountList = AccountList.fromJson(list);
  return accountList;
}