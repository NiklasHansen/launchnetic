import '../database_provider.dart';

abstract class Repository<T> {
  DatabaseProvider databaseProvider;

  Future<T> insert(T value);
  Future<T> update(T value);
  Future<T> delete(T value);
}
