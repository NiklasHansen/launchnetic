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
}
