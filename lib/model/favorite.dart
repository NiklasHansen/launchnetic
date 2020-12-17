import 'package:flutter/widgets.dart';

class Favorite {
  int id;
  String appName;
  String packageName;
  Image icon;
  int order;

  Favorite(this.id, this.appName, this.packageName, this.icon, this.order);
}
