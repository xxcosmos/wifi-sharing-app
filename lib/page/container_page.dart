import 'package:flutter/material.dart';

class ContainerPage extends StatefulWidget {
  @override
  _ContainerPageState createState() => _ContainerPageState();
}
class _Item{
  String name;
  Icon activeIcon,normalIcon;

  _Item(this.name, this.activeIcon, this.normalIcon);

}

class _ContainerPageState extends State<ContainerPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
