import 'local_database.dart';

/// A single shared database instance used across the whole app.
class DBProvider {
  static final LocalDatabase database = LocalDatabase();
}