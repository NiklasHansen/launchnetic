import 'package:device_apps/device_apps.dart';
import 'package:flutter/widgets.dart';
import 'package:launchnetic/dao/favorite_dao.dart';
import 'package:launchnetic/database_provider.dart';
import 'package:launchnetic/model/favorite.dart';
import 'package:launchnetic/repository/repository.dart';

class FavoritesRepository implements Repository<Favorite> {
  final dao = FavoriteDao();

  @override
  DatabaseProvider databaseProvider;

  FavoritesRepository(this.databaseProvider);

  @override
  Future<Favorite> delete(Favorite value) async {
    final db = await databaseProvider.db();
    await db.delete(dao.tableName,
        where: dao.columnId + " = ?", whereArgs: [value.id]);
    return value;
  }

  @override
  Future<Favorite> insert(Favorite value) async {
    final db = await databaseProvider.db();
    value.id = await db.insert(dao.tableName, dao.toMap(value));
    return value;
  }

  @override
  Future<Favorite> update(Favorite value) async {
    final db = await databaseProvider.db();
    await db.update(dao.tableName, dao.toMap(value),
        where: dao.columnId + " = ?", whereArgs: [value.id]);
    return value;
  }

  Future<List<Favorite>> getFavorites() async {
    final db = await databaseProvider.db();
    var results = await db.query(dao.tableName, orderBy: dao.columnOrder);
    var favorites = List<Favorite>();

    for (var i = 0; i < results.length; i++) {
      var fav = dao.fromMap(results[i]);

      if (!await DeviceApps.isAppInstalled(fav.packageName)) {
        delete(fav);
        continue;
      }

      var app = await DeviceApps.getApp(fav.packageName);
      fav.appName = app.appName;
      if (app is ApplicationWithIcon) {
        fav.icon = Image.memory(app.icon);
      }

      favorites.add(fav);
    }

    return favorites;
  }
}
