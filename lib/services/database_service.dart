import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_management/models/app_usage.dart';
import 'package:app_management/models/category.dart';
import 'package:app_management/utils/constants.dart';
import 'package:app_management/utils/default_categories.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), AppConstants.dbName);
    return openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon INTEGER NOT NULL,
        color INTEGER NOT NULL,
        daily_limit_minutes INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE app_category_map (
        package_name TEXT PRIMARY KEY,
        category_id INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE usage_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        package_name TEXT NOT NULL,
        app_name TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        usage_minutes INTEGER NOT NULL,
        date TEXT NOT NULL,
        UNIQUE(package_name, date),
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    for (final category in DefaultCategories.all) {
      await db.insert('categories', category.toMap());
    }
  }

  // --- Categories ---

  Future<List<Category>> getCategories() async {
    final db = await database;
    final maps = await db.query('categories');
    return maps.map((m) => Category.fromMap(m)).toList();
  }

  Future<int> updateCategoryLimit(int categoryId, int limitMinutes) async {
    final db = await database;
    return db.update(
      'categories',
      {'daily_limit_minutes': limitMinutes},
      where: 'id = ?',
      whereArgs: [categoryId],
    );
  }

  // --- App Category Mapping ---

  Future<void> setAppCategory(String packageName, int categoryId) async {
    final db = await database;
    await db.insert(
      'app_category_map',
      {'package_name': packageName, 'category_id': categoryId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int?> getAppCategory(String packageName) async {
    final db = await database;
    final result = await db.query(
      'app_category_map',
      where: 'package_name = ?',
      whereArgs: [packageName],
    );
    if (result.isEmpty) return null;
    return result.first['category_id'] as int;
  }

  Future<Map<String, int>> getAllAppCategoryMappings() async {
    final db = await database;
    final result = await db.query('app_category_map');
    return {
      for (final row in result)
        row['package_name'] as String: row['category_id'] as int,
    };
  }

  // --- Usage Records ---

  Future<void> upsertUsageRecord(AppUsage usage) async {
    final db = await database;
    await db.insert(
      'usage_records',
      usage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertUsageRecords(List<AppUsage> records) async {
    final db = await database;
    final batch = db.batch();
    for (final record in records) {
      batch.insert(
        'usage_records',
        record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<AppUsage>> getUsageForDate(String date) async {
    final db = await database;
    final maps = await db.query(
      'usage_records',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'usage_minutes DESC',
    );
    return maps.map((m) => AppUsage.fromMap(m)).toList();
  }

  Future<List<Map<String, dynamic>>> getCategorySummaryForDate(String date) async {
    final db = await database;
    return db.rawQuery('''
      SELECT
        c.id as category_id,
        c.name as category_name,
        c.daily_limit_minutes as limit_minutes,
        COALESCE(SUM(u.usage_minutes), 0) as total_minutes,
        COUNT(u.package_name) as app_count
      FROM categories c
      LEFT JOIN usage_records u ON c.id = u.category_id AND u.date = ?
      GROUP BY c.id
      ORDER BY total_minutes DESC
    ''', [date]);
  }

  Future<List<AppUsage>> getUsageForCategoryAndDate(int categoryId, String date) async {
    final db = await database;
    final maps = await db.query(
      'usage_records',
      where: 'category_id = ? AND date = ?',
      whereArgs: [categoryId, date],
      orderBy: 'usage_minutes DESC',
    );
    return maps.map((m) => AppUsage.fromMap(m)).toList();
  }

  Future<int> getTotalUsageForDate(String date) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(usage_minutes), 0) as total FROM usage_records WHERE date = ?',
      [date],
    );
    return result.first['total'] as int;
  }
}
