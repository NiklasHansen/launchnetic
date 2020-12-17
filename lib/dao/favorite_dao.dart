import 'package:flutter/widgets.dart';
import 'package:launchnetic/model/favorite.dart';

import 'dao.dart';

class FavoriteDao implements Dao<Favorite> {
  final tableName = 'favorites';
  final columnId = 'id';
  final columnPackageName = 'package';
  final columnOrder = 'order';

  @override
  String get createTableQuery =>
      "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY,"
      " $columnPackageName TEXT,"
      " $columnOrder INTEGER)";

  @override
  List<Favorite> fromList(List<Map<String, dynamic>> query) {
    var favorites = List<Favorite>();
    for (Map map in query) {
      favorites.add(fromMap(map));
    }

    return favorites;
  }

  @override
  fromMap(Map<String, dynamic> query) {
    var id = query[columnId];
    var appName = ""; // TODO: Retrieve app?
    var packageName = query[columnPackageName];
    Image icon = null;
    var order = query[columnOrder];

    return Favorite(id, appName, packageName, icon, order);
  }

  @override
  Map<String, dynamic> toMap(Favorite object) {
    return <String, dynamic>{
      columnId: object.id,
      columnPackageName: object.packageName,
      columnOrder: object.order
    };
  }
}
