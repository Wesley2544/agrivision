import 'local_database.dart';

/// Single shared database instance for the entire app.
/// Access via DBProvider.db anywhere in your code.
class DBProvider {
  DBProvider._();

  static final LocalDatabase db = LocalDatabase();
}