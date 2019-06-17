class Account
{
  String username;
  String  idNumber;


  Account({this.username, this.idNumber});

  factory Account.fromJson(Map<String,dynamic> json){
    return Account(idNumber: json['idNumber'],username: json['username']);
  }
}

class AccountList{
  List<Account> accountList;

  AccountList({this.accountList});

  factory AccountList.fromJson(List<dynamic> listJson){
    List<Account> accountList = listJson.map((value)=>Account.fromJson(value)).toList();
    return AccountList(accountList: accountList);
  }
}