import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get postId => text().withLength(min: 6, max: 8)();

  TextColumn get title => text().withLength(min: 6, max: 32)();

  TextColumn get contentRendered => text()();

  TextColumn get contentText => text()();

  TextColumn get createDate => text().withLength(max: 28)();

  TextColumn get createDateAgo => text().withLength(max: 26)();

  TextColumn get lastReplyDate => text().withLength(max: 28)();

  TextColumn get lastReplyDateAgo => text().withLength(max: 26)();

  TextColumn get lastReplyUsername => text().withLength(max: 20)();

  IntColumn get replyCount => integer().withDefault(Constant(0))();

  IntColumn get clickCount => integer().withDefault(Constant(0))();

  IntColumn get thankCount => integer().withDefault(Constant(0))();

  IntColumn get collectCount => integer().withDefault(Constant(0))();

  BoolColumn get isTop => boolean().withDefault(Constant(false))();

  BoolColumn get isFavorite => boolean().withDefault(Constant(false))();

  BoolColumn get isIgnore => boolean().withDefault(Constant(false))();

  BoolColumn get isThanked => boolean().withDefault(Constant(false))();

  BoolColumn get isReport => boolean().withDefault(Constant(false))();

  BoolColumn get isAppend => boolean().withDefault(Constant(false))();

  BoolColumn get isEdit => boolean().withDefault(Constant(false))();

  BoolColumn get isMove => boolean().withDefault(Constant(false))();
}

class TodoCategory extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get description => text()();
}

@DriftDatabase(tables: [TodoItems, TodoCategory])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 8;

  static QueryExecutor _openConnection() {
    // driftDatabase from package:drift_flutter stores the database in
    // getApplicationDocumentsDirectory().
    return driftDatabase(name: 'my_database');
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(onUpgrade: (migrator, from, to) async {
        if (from == 2) {
          // await migrator.dropColumn(todoItems, 'postId'); // 添加新列
          // await migrator.addColumn(todoItems, todoItems.postId); // 添加新列
        }
      }, beforeOpen: (openingDetails) async {
        if (true /* or some other flag */) {
          final m = this.createMigrator(); // changed to this
          for (final table in allTables) {
            await m.deleteTable(table.actualTableName);
            await m.createTable(table);
          }
        }
      });
}
