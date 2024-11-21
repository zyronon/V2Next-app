import 'dart:convert';
import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:v2next/model/model.dart';

part 'database.g.dart';

class DbPost extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get postId => integer().withDefault(Constant(0))();

  TextColumn get title => text().withLength(max: 142)();

  TextColumn get contentRendered => text()();

  TextColumn get contentText => text()();

  TextColumn get createDate => text().withLength(max: 28)();

  TextColumn get createDateAgo => text().withLength(max: 26)();

  TextColumn get lastReplyDate => text().withLength(max: 28)();

  TextColumn get lastReplyDateAgo => text().withLength(max: 26)();

  TextColumn get lastReplyUsername => text().withLength(max: 20)();

  TextColumn get nodeTitle => text().withLength(max: 30)();

  TextColumn get nodeName => text().withLength(max: 20)();

  TextColumn get memberAvatar => text()();

  TextColumn get memberUsername => text().withLength(max: 20)();

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

  DateTimeColumn get createdTime => dateTime().withDefault(currentDateAndTime)();
}

class DbReply extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 外键关联到 Posts 表
  IntColumn get postAutoId => integer().customConstraint('REFERENCES dbPost(id)')();

  IntColumn get replyId => integer().withDefault(Constant(0))();

  TextColumn get replyContent => text()();

  TextColumn get replyUsers => text()();

  TextColumn get replyText => text()();

  TextColumn get date => text()();

  TextColumn get platform => text()();

  TextColumn get avatar => text()();

  TextColumn get username => text().withLength(max: 100)();

  IntColumn get level => integer().withDefault(Constant(0))();

  IntColumn get floor => integer().withDefault(Constant(0))();

  IntColumn get thankCount => integer().withDefault(Constant(0))();

  IntColumn get replyCount => integer().withDefault(Constant(0))();

  IntColumn get replyFloor => integer().withDefault(Constant(0))();

  BoolColumn get isThanked => boolean().withDefault(Constant(false))();

  BoolColumn get isOp => boolean().withDefault(Constant(false))();

  BoolColumn get isDup => boolean().withDefault(Constant(false))();

  BoolColumn get isMod => boolean().withDefault(Constant(false))();

  BoolColumn get isUse => boolean().withDefault(Constant(false))();

  BoolColumn get isChoose => boolean().withDefault(Constant(false))();

  BoolColumn get isWrong => boolean().withDefault(Constant(false))();

  DateTimeColumn get createdTime => dateTime().withDefault(currentDateAndTime)();
}

class PostWithReplies {
  final DbPostData post;
  final List<DbReplyData> replies;

  PostWithReplies({
    required this.post,
    required this.replies,
  });
}

@DriftDatabase(tables: [DbPost, DbReply], daos: [PostDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 11;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'my_database');
  }

  //TODO 未测试
  Future<void> deleteOldRecords() async {
    // 计算15天前的日期
    final threeMonthsAgo = DateTime.now().subtract(Duration(days: 15));
    await (delete(dbPost)..where((record) => record.createdTime.isSmallerThanValue(threeMonthsAgo))).go();
    await (delete(dbReply)..where((record) => record.createdTime.isSmallerThanValue(threeMonthsAgo))).go();
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(onUpgrade: (migrator, from, to) async {
        if (from == 4) {
          // await migrator.dropColumn(todoItems, 'postId'); // 添加新列
          // await migrator.addColumn(todoItems, todoItems.postId); // 添加新列
        }
      }, beforeOpen: (openingDetails) async {
        if (true /* or some other flag */) {
          // final m = this.createMigrator(); // changed to this
          // for (final table in allTables) {
          //   await m.deleteTable(table.actualTableName);
          //   await m.createTable(table);
          // }
        }
      });
}

@DriftAccessor(tables: [DbPostCompanion, DbReplyCompanion])
class PostDao extends DatabaseAccessor<AppDatabase> with _$PostDaoMixin {
  final AppDatabase db;

  PostDao(this.db) : super(db);

  // 插入 Post 的方法
  Future<int> insertPost(Post post, List<Reply> replies) async {
    int postAutoId = await into(db.dbPost).insert(DbPostCompanion(
      postId: Value(post.postId),
      title: Value(post.title),
      contentRendered: Value(post.contentRendered),
      contentText: Value(post.contentText),
      createDate: Value(post.createDate),
      createDateAgo: Value(post.createDateAgo),
      lastReplyDate: Value(post.lastReplyDate),
      lastReplyDateAgo: Value(post.lastReplyDateAgo),
      lastReplyUsername: Value(post.lastReplyUsername),
      nodeName: Value(post.node.name),
      nodeTitle: Value(post.node.title),
      memberAvatar: Value(post.member.avatar),
      memberUsername: Value(post.member.username),
      replyCount: Value(post.replyCount),
      thankCount: Value(post.thankCount),
      collectCount: Value(post.collectCount),
      clickCount: Value(post.clickCount),
      isTop: Value(post.isTop),
      isFavorite: Value(post.isFavorite),
      isIgnore: Value(post.isIgnore),
      isThanked: Value(post.isThanked),
      isReport: Value(post.isReport),
      isAppend: Value(post.isAppend),
      isEdit: Value(post.isEdit),
      isMove: Value(post.isMove),
    ));
    replies.forEach((reply) async {
      await insertReply(postAutoId, reply);
    });
    return postAutoId;
  }

  Future<void> updatePost(Post post, List<Reply> replies) async {
    final dbRost = await (select(db.dbPost)..where((tbl) => tbl.postId.equals(post.postId))).getSingleOrNull();
    final query = update(db.dbPost)..where((tbl) => tbl.postId.equals(post.postId));

    await query.write(DbPostCompanion(
      title: Value(post.title),
      contentRendered: Value(post.contentRendered),
      contentText: Value(post.contentText),
      createDate: Value(post.createDate),
      createDateAgo: Value(post.createDateAgo),
      lastReplyDate: Value(post.lastReplyDate),
      lastReplyDateAgo: Value(post.lastReplyDateAgo),
      lastReplyUsername: Value(post.lastReplyUsername),
      replyCount: Value(post.replyCount),
      thankCount: Value(post.thankCount),
      collectCount: Value(post.collectCount),
      isTop: Value(post.isTop),
      isFavorite: Value(post.isFavorite),
      isIgnore: Value(post.isIgnore),
      isThanked: Value(post.isThanked),
      isReport: Value(post.isReport),
      isAppend: Value(post.isAppend),
      isEdit: Value(post.isEdit),
      isMove: Value(post.isMove),
    ));

    final delQuery = delete(db.dbReply)..where((tbl) => tbl.postAutoId.equals(dbRost!.id));
    await delQuery.go(); // 执行删除操作
    //重新添加
    replies.forEach((reply) async {
      await insertReply(dbRost!.id, reply);
    });
  }

  //  插入 Reply 的方法
  Future<int> insertReply(int postAutoId, Reply reply) async {
    return await into(db.dbReply).insert(DbReplyCompanion(
      postAutoId: Value(postAutoId),
      replyId: Value(reply.replyId),
      level: Value(reply.level),
      thankCount: Value(reply.thankCount),
      replyCount: Value(reply.replyCount),
      isThanked: Value(reply.isThanked),
      isOp: Value(reply.isOp),
      isMod: Value(reply.isMod),
      isUse: Value(reply.isUse),
      isChoose: Value(reply.isChoose),
      isWrong: Value(reply.isWrong),
      replyContent: Value(reply.replyContent),
      replyText: Value(reply.replyText),
      replyUsers: Value(jsonEncode(reply.replyUsers)),
      replyFloor: Value(reply.replyFloor),
      date: Value(reply.date),
      platform: Value(reply.platform),
      username: Value(reply.username),
      avatar: Value(reply.avatar),
      floor: Value(reply.floor),
    ));
  }

  Future<PostWithReplies?> getPostWithReplies(int postId) async {
    final post = await (select(db.dbPost)..where((tbl) => tbl.postId.equals(postId))).getSingleOrNull();
    if (post == null) return null;
    final replies = await (select(db.dbReply)..where((tbl) => tbl.postAutoId.equals(post.id))).get();
    return PostWithReplies(post: post, replies: replies);
  }
}
