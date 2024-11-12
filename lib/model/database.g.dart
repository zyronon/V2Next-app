// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DbPostTable extends DbPost with TableInfo<$DbPostTable, DbPostData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbPostTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<int> postId = GeneratedColumn<int>(
      'post_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 142),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contentRenderedMeta =
      const VerificationMeta('contentRendered');
  @override
  late final GeneratedColumn<String> contentRendered = GeneratedColumn<String>(
      'content_rendered', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentTextMeta =
      const VerificationMeta('contentText');
  @override
  late final GeneratedColumn<String> contentText = GeneratedColumn<String>(
      'content_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createDateMeta =
      const VerificationMeta('createDate');
  @override
  late final GeneratedColumn<String> createDate = GeneratedColumn<String>(
      'create_date', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 28),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createDateAgoMeta =
      const VerificationMeta('createDateAgo');
  @override
  late final GeneratedColumn<String> createDateAgo = GeneratedColumn<String>(
      'create_date_ago', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 26),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _lastReplyDateMeta =
      const VerificationMeta('lastReplyDate');
  @override
  late final GeneratedColumn<String> lastReplyDate = GeneratedColumn<String>(
      'last_reply_date', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 28),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _lastReplyDateAgoMeta =
      const VerificationMeta('lastReplyDateAgo');
  @override
  late final GeneratedColumn<String> lastReplyDateAgo = GeneratedColumn<String>(
      'last_reply_date_ago', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 26),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _lastReplyUsernameMeta =
      const VerificationMeta('lastReplyUsername');
  @override
  late final GeneratedColumn<String> lastReplyUsername =
      GeneratedColumn<String>('last_reply_username', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _nodeTitleMeta =
      const VerificationMeta('nodeTitle');
  @override
  late final GeneratedColumn<String> nodeTitle = GeneratedColumn<String>(
      'node_title', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nodeNameMeta =
      const VerificationMeta('nodeName');
  @override
  late final GeneratedColumn<String> nodeName = GeneratedColumn<String>(
      'node_name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _memberAvatarMeta =
      const VerificationMeta('memberAvatar');
  @override
  late final GeneratedColumn<String> memberAvatar = GeneratedColumn<String>(
      'member_avatar', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memberUsernameMeta =
      const VerificationMeta('memberUsername');
  @override
  late final GeneratedColumn<String> memberUsername = GeneratedColumn<String>(
      'member_username', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _replyCountMeta =
      const VerificationMeta('replyCount');
  @override
  late final GeneratedColumn<int> replyCount = GeneratedColumn<int>(
      'reply_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _clickCountMeta =
      const VerificationMeta('clickCount');
  @override
  late final GeneratedColumn<int> clickCount = GeneratedColumn<int>(
      'click_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _thankCountMeta =
      const VerificationMeta('thankCount');
  @override
  late final GeneratedColumn<int> thankCount = GeneratedColumn<int>(
      'thank_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _collectCountMeta =
      const VerificationMeta('collectCount');
  @override
  late final GeneratedColumn<int> collectCount = GeneratedColumn<int>(
      'collect_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _isTopMeta = const VerificationMeta('isTop');
  @override
  late final GeneratedColumn<bool> isTop = GeneratedColumn<bool>(
      'is_top', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_top" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isIgnoreMeta =
      const VerificationMeta('isIgnore');
  @override
  late final GeneratedColumn<bool> isIgnore = GeneratedColumn<bool>(
      'is_ignore', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_ignore" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isThankedMeta =
      const VerificationMeta('isThanked');
  @override
  late final GeneratedColumn<bool> isThanked = GeneratedColumn<bool>(
      'is_thanked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_thanked" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isReportMeta =
      const VerificationMeta('isReport');
  @override
  late final GeneratedColumn<bool> isReport = GeneratedColumn<bool>(
      'is_report', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_report" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isAppendMeta =
      const VerificationMeta('isAppend');
  @override
  late final GeneratedColumn<bool> isAppend = GeneratedColumn<bool>(
      'is_append', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_append" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isEditMeta = const VerificationMeta('isEdit');
  @override
  late final GeneratedColumn<bool> isEdit = GeneratedColumn<bool>(
      'is_edit', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_edit" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isMoveMeta = const VerificationMeta('isMove');
  @override
  late final GeneratedColumn<bool> isMove = GeneratedColumn<bool>(
      'is_move', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_move" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _createdTimeMeta =
      const VerificationMeta('createdTime');
  @override
  late final GeneratedColumn<DateTime> createdTime = GeneratedColumn<DateTime>(
      'created_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        postId,
        title,
        contentRendered,
        contentText,
        createDate,
        createDateAgo,
        lastReplyDate,
        lastReplyDateAgo,
        lastReplyUsername,
        nodeTitle,
        nodeName,
        memberAvatar,
        memberUsername,
        replyCount,
        clickCount,
        thankCount,
        collectCount,
        isTop,
        isFavorite,
        isIgnore,
        isThanked,
        isReport,
        isAppend,
        isEdit,
        isMove,
        createdTime
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_post';
  @override
  VerificationContext validateIntegrity(Insertable<DbPostData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('post_id')) {
      context.handle(_postIdMeta,
          postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content_rendered')) {
      context.handle(
          _contentRenderedMeta,
          contentRendered.isAcceptableOrUnknown(
              data['content_rendered']!, _contentRenderedMeta));
    } else if (isInserting) {
      context.missing(_contentRenderedMeta);
    }
    if (data.containsKey('content_text')) {
      context.handle(
          _contentTextMeta,
          contentText.isAcceptableOrUnknown(
              data['content_text']!, _contentTextMeta));
    } else if (isInserting) {
      context.missing(_contentTextMeta);
    }
    if (data.containsKey('create_date')) {
      context.handle(
          _createDateMeta,
          createDate.isAcceptableOrUnknown(
              data['create_date']!, _createDateMeta));
    } else if (isInserting) {
      context.missing(_createDateMeta);
    }
    if (data.containsKey('create_date_ago')) {
      context.handle(
          _createDateAgoMeta,
          createDateAgo.isAcceptableOrUnknown(
              data['create_date_ago']!, _createDateAgoMeta));
    } else if (isInserting) {
      context.missing(_createDateAgoMeta);
    }
    if (data.containsKey('last_reply_date')) {
      context.handle(
          _lastReplyDateMeta,
          lastReplyDate.isAcceptableOrUnknown(
              data['last_reply_date']!, _lastReplyDateMeta));
    } else if (isInserting) {
      context.missing(_lastReplyDateMeta);
    }
    if (data.containsKey('last_reply_date_ago')) {
      context.handle(
          _lastReplyDateAgoMeta,
          lastReplyDateAgo.isAcceptableOrUnknown(
              data['last_reply_date_ago']!, _lastReplyDateAgoMeta));
    } else if (isInserting) {
      context.missing(_lastReplyDateAgoMeta);
    }
    if (data.containsKey('last_reply_username')) {
      context.handle(
          _lastReplyUsernameMeta,
          lastReplyUsername.isAcceptableOrUnknown(
              data['last_reply_username']!, _lastReplyUsernameMeta));
    } else if (isInserting) {
      context.missing(_lastReplyUsernameMeta);
    }
    if (data.containsKey('node_title')) {
      context.handle(_nodeTitleMeta,
          nodeTitle.isAcceptableOrUnknown(data['node_title']!, _nodeTitleMeta));
    } else if (isInserting) {
      context.missing(_nodeTitleMeta);
    }
    if (data.containsKey('node_name')) {
      context.handle(_nodeNameMeta,
          nodeName.isAcceptableOrUnknown(data['node_name']!, _nodeNameMeta));
    } else if (isInserting) {
      context.missing(_nodeNameMeta);
    }
    if (data.containsKey('member_avatar')) {
      context.handle(
          _memberAvatarMeta,
          memberAvatar.isAcceptableOrUnknown(
              data['member_avatar']!, _memberAvatarMeta));
    } else if (isInserting) {
      context.missing(_memberAvatarMeta);
    }
    if (data.containsKey('member_username')) {
      context.handle(
          _memberUsernameMeta,
          memberUsername.isAcceptableOrUnknown(
              data['member_username']!, _memberUsernameMeta));
    } else if (isInserting) {
      context.missing(_memberUsernameMeta);
    }
    if (data.containsKey('reply_count')) {
      context.handle(
          _replyCountMeta,
          replyCount.isAcceptableOrUnknown(
              data['reply_count']!, _replyCountMeta));
    }
    if (data.containsKey('click_count')) {
      context.handle(
          _clickCountMeta,
          clickCount.isAcceptableOrUnknown(
              data['click_count']!, _clickCountMeta));
    }
    if (data.containsKey('thank_count')) {
      context.handle(
          _thankCountMeta,
          thankCount.isAcceptableOrUnknown(
              data['thank_count']!, _thankCountMeta));
    }
    if (data.containsKey('collect_count')) {
      context.handle(
          _collectCountMeta,
          collectCount.isAcceptableOrUnknown(
              data['collect_count']!, _collectCountMeta));
    }
    if (data.containsKey('is_top')) {
      context.handle(
          _isTopMeta, isTop.isAcceptableOrUnknown(data['is_top']!, _isTopMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('is_ignore')) {
      context.handle(_isIgnoreMeta,
          isIgnore.isAcceptableOrUnknown(data['is_ignore']!, _isIgnoreMeta));
    }
    if (data.containsKey('is_thanked')) {
      context.handle(_isThankedMeta,
          isThanked.isAcceptableOrUnknown(data['is_thanked']!, _isThankedMeta));
    }
    if (data.containsKey('is_report')) {
      context.handle(_isReportMeta,
          isReport.isAcceptableOrUnknown(data['is_report']!, _isReportMeta));
    }
    if (data.containsKey('is_append')) {
      context.handle(_isAppendMeta,
          isAppend.isAcceptableOrUnknown(data['is_append']!, _isAppendMeta));
    }
    if (data.containsKey('is_edit')) {
      context.handle(_isEditMeta,
          isEdit.isAcceptableOrUnknown(data['is_edit']!, _isEditMeta));
    }
    if (data.containsKey('is_move')) {
      context.handle(_isMoveMeta,
          isMove.isAcceptableOrUnknown(data['is_move']!, _isMoveMeta));
    }
    if (data.containsKey('created_time')) {
      context.handle(
          _createdTimeMeta,
          createdTime.isAcceptableOrUnknown(
              data['created_time']!, _createdTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbPostData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbPostData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      postId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}post_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      contentRendered: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}content_rendered'])!,
      contentText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_text'])!,
      createDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}create_date'])!,
      createDateAgo: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}create_date_ago'])!,
      lastReplyDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_reply_date'])!,
      lastReplyDateAgo: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_reply_date_ago'])!,
      lastReplyUsername: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_reply_username'])!,
      nodeTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}node_title'])!,
      nodeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}node_name'])!,
      memberAvatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}member_avatar'])!,
      memberUsername: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}member_username'])!,
      replyCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reply_count'])!,
      clickCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}click_count'])!,
      thankCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}thank_count'])!,
      collectCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}collect_count'])!,
      isTop: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_top'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      isIgnore: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_ignore'])!,
      isThanked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_thanked'])!,
      isReport: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_report'])!,
      isAppend: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_append'])!,
      isEdit: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_edit'])!,
      isMove: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_move'])!,
      createdTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_time'])!,
    );
  }

  @override
  $DbPostTable createAlias(String alias) {
    return $DbPostTable(attachedDatabase, alias);
  }
}

class DbPostData extends DataClass implements Insertable<DbPostData> {
  final int id;
  final int postId;
  final String title;
  final String contentRendered;
  final String contentText;
  final String createDate;
  final String createDateAgo;
  final String lastReplyDate;
  final String lastReplyDateAgo;
  final String lastReplyUsername;
  final String nodeTitle;
  final String nodeName;
  final String memberAvatar;
  final String memberUsername;
  final int replyCount;
  final int clickCount;
  final int thankCount;
  final int collectCount;
  final bool isTop;
  final bool isFavorite;
  final bool isIgnore;
  final bool isThanked;
  final bool isReport;
  final bool isAppend;
  final bool isEdit;
  final bool isMove;
  final DateTime createdTime;
  const DbPostData(
      {required this.id,
      required this.postId,
      required this.title,
      required this.contentRendered,
      required this.contentText,
      required this.createDate,
      required this.createDateAgo,
      required this.lastReplyDate,
      required this.lastReplyDateAgo,
      required this.lastReplyUsername,
      required this.nodeTitle,
      required this.nodeName,
      required this.memberAvatar,
      required this.memberUsername,
      required this.replyCount,
      required this.clickCount,
      required this.thankCount,
      required this.collectCount,
      required this.isTop,
      required this.isFavorite,
      required this.isIgnore,
      required this.isThanked,
      required this.isReport,
      required this.isAppend,
      required this.isEdit,
      required this.isMove,
      required this.createdTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['post_id'] = Variable<int>(postId);
    map['title'] = Variable<String>(title);
    map['content_rendered'] = Variable<String>(contentRendered);
    map['content_text'] = Variable<String>(contentText);
    map['create_date'] = Variable<String>(createDate);
    map['create_date_ago'] = Variable<String>(createDateAgo);
    map['last_reply_date'] = Variable<String>(lastReplyDate);
    map['last_reply_date_ago'] = Variable<String>(lastReplyDateAgo);
    map['last_reply_username'] = Variable<String>(lastReplyUsername);
    map['node_title'] = Variable<String>(nodeTitle);
    map['node_name'] = Variable<String>(nodeName);
    map['member_avatar'] = Variable<String>(memberAvatar);
    map['member_username'] = Variable<String>(memberUsername);
    map['reply_count'] = Variable<int>(replyCount);
    map['click_count'] = Variable<int>(clickCount);
    map['thank_count'] = Variable<int>(thankCount);
    map['collect_count'] = Variable<int>(collectCount);
    map['is_top'] = Variable<bool>(isTop);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_ignore'] = Variable<bool>(isIgnore);
    map['is_thanked'] = Variable<bool>(isThanked);
    map['is_report'] = Variable<bool>(isReport);
    map['is_append'] = Variable<bool>(isAppend);
    map['is_edit'] = Variable<bool>(isEdit);
    map['is_move'] = Variable<bool>(isMove);
    map['created_time'] = Variable<DateTime>(createdTime);
    return map;
  }

  DbPostCompanion toCompanion(bool nullToAbsent) {
    return DbPostCompanion(
      id: Value(id),
      postId: Value(postId),
      title: Value(title),
      contentRendered: Value(contentRendered),
      contentText: Value(contentText),
      createDate: Value(createDate),
      createDateAgo: Value(createDateAgo),
      lastReplyDate: Value(lastReplyDate),
      lastReplyDateAgo: Value(lastReplyDateAgo),
      lastReplyUsername: Value(lastReplyUsername),
      nodeTitle: Value(nodeTitle),
      nodeName: Value(nodeName),
      memberAvatar: Value(memberAvatar),
      memberUsername: Value(memberUsername),
      replyCount: Value(replyCount),
      clickCount: Value(clickCount),
      thankCount: Value(thankCount),
      collectCount: Value(collectCount),
      isTop: Value(isTop),
      isFavorite: Value(isFavorite),
      isIgnore: Value(isIgnore),
      isThanked: Value(isThanked),
      isReport: Value(isReport),
      isAppend: Value(isAppend),
      isEdit: Value(isEdit),
      isMove: Value(isMove),
      createdTime: Value(createdTime),
    );
  }

  factory DbPostData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbPostData(
      id: serializer.fromJson<int>(json['id']),
      postId: serializer.fromJson<int>(json['postId']),
      title: serializer.fromJson<String>(json['title']),
      contentRendered: serializer.fromJson<String>(json['contentRendered']),
      contentText: serializer.fromJson<String>(json['contentText']),
      createDate: serializer.fromJson<String>(json['createDate']),
      createDateAgo: serializer.fromJson<String>(json['createDateAgo']),
      lastReplyDate: serializer.fromJson<String>(json['lastReplyDate']),
      lastReplyDateAgo: serializer.fromJson<String>(json['lastReplyDateAgo']),
      lastReplyUsername: serializer.fromJson<String>(json['lastReplyUsername']),
      nodeTitle: serializer.fromJson<String>(json['nodeTitle']),
      nodeName: serializer.fromJson<String>(json['nodeName']),
      memberAvatar: serializer.fromJson<String>(json['memberAvatar']),
      memberUsername: serializer.fromJson<String>(json['memberUsername']),
      replyCount: serializer.fromJson<int>(json['replyCount']),
      clickCount: serializer.fromJson<int>(json['clickCount']),
      thankCount: serializer.fromJson<int>(json['thankCount']),
      collectCount: serializer.fromJson<int>(json['collectCount']),
      isTop: serializer.fromJson<bool>(json['isTop']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isIgnore: serializer.fromJson<bool>(json['isIgnore']),
      isThanked: serializer.fromJson<bool>(json['isThanked']),
      isReport: serializer.fromJson<bool>(json['isReport']),
      isAppend: serializer.fromJson<bool>(json['isAppend']),
      isEdit: serializer.fromJson<bool>(json['isEdit']),
      isMove: serializer.fromJson<bool>(json['isMove']),
      createdTime: serializer.fromJson<DateTime>(json['createdTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'postId': serializer.toJson<int>(postId),
      'title': serializer.toJson<String>(title),
      'contentRendered': serializer.toJson<String>(contentRendered),
      'contentText': serializer.toJson<String>(contentText),
      'createDate': serializer.toJson<String>(createDate),
      'createDateAgo': serializer.toJson<String>(createDateAgo),
      'lastReplyDate': serializer.toJson<String>(lastReplyDate),
      'lastReplyDateAgo': serializer.toJson<String>(lastReplyDateAgo),
      'lastReplyUsername': serializer.toJson<String>(lastReplyUsername),
      'nodeTitle': serializer.toJson<String>(nodeTitle),
      'nodeName': serializer.toJson<String>(nodeName),
      'memberAvatar': serializer.toJson<String>(memberAvatar),
      'memberUsername': serializer.toJson<String>(memberUsername),
      'replyCount': serializer.toJson<int>(replyCount),
      'clickCount': serializer.toJson<int>(clickCount),
      'thankCount': serializer.toJson<int>(thankCount),
      'collectCount': serializer.toJson<int>(collectCount),
      'isTop': serializer.toJson<bool>(isTop),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isIgnore': serializer.toJson<bool>(isIgnore),
      'isThanked': serializer.toJson<bool>(isThanked),
      'isReport': serializer.toJson<bool>(isReport),
      'isAppend': serializer.toJson<bool>(isAppend),
      'isEdit': serializer.toJson<bool>(isEdit),
      'isMove': serializer.toJson<bool>(isMove),
      'createdTime': serializer.toJson<DateTime>(createdTime),
    };
  }

  DbPostData copyWith(
          {int? id,
          int? postId,
          String? title,
          String? contentRendered,
          String? contentText,
          String? createDate,
          String? createDateAgo,
          String? lastReplyDate,
          String? lastReplyDateAgo,
          String? lastReplyUsername,
          String? nodeTitle,
          String? nodeName,
          String? memberAvatar,
          String? memberUsername,
          int? replyCount,
          int? clickCount,
          int? thankCount,
          int? collectCount,
          bool? isTop,
          bool? isFavorite,
          bool? isIgnore,
          bool? isThanked,
          bool? isReport,
          bool? isAppend,
          bool? isEdit,
          bool? isMove,
          DateTime? createdTime}) =>
      DbPostData(
        id: id ?? this.id,
        postId: postId ?? this.postId,
        title: title ?? this.title,
        contentRendered: contentRendered ?? this.contentRendered,
        contentText: contentText ?? this.contentText,
        createDate: createDate ?? this.createDate,
        createDateAgo: createDateAgo ?? this.createDateAgo,
        lastReplyDate: lastReplyDate ?? this.lastReplyDate,
        lastReplyDateAgo: lastReplyDateAgo ?? this.lastReplyDateAgo,
        lastReplyUsername: lastReplyUsername ?? this.lastReplyUsername,
        nodeTitle: nodeTitle ?? this.nodeTitle,
        nodeName: nodeName ?? this.nodeName,
        memberAvatar: memberAvatar ?? this.memberAvatar,
        memberUsername: memberUsername ?? this.memberUsername,
        replyCount: replyCount ?? this.replyCount,
        clickCount: clickCount ?? this.clickCount,
        thankCount: thankCount ?? this.thankCount,
        collectCount: collectCount ?? this.collectCount,
        isTop: isTop ?? this.isTop,
        isFavorite: isFavorite ?? this.isFavorite,
        isIgnore: isIgnore ?? this.isIgnore,
        isThanked: isThanked ?? this.isThanked,
        isReport: isReport ?? this.isReport,
        isAppend: isAppend ?? this.isAppend,
        isEdit: isEdit ?? this.isEdit,
        isMove: isMove ?? this.isMove,
        createdTime: createdTime ?? this.createdTime,
      );
  DbPostData copyWithCompanion(DbPostCompanion data) {
    return DbPostData(
      id: data.id.present ? data.id.value : this.id,
      postId: data.postId.present ? data.postId.value : this.postId,
      title: data.title.present ? data.title.value : this.title,
      contentRendered: data.contentRendered.present
          ? data.contentRendered.value
          : this.contentRendered,
      contentText:
          data.contentText.present ? data.contentText.value : this.contentText,
      createDate:
          data.createDate.present ? data.createDate.value : this.createDate,
      createDateAgo: data.createDateAgo.present
          ? data.createDateAgo.value
          : this.createDateAgo,
      lastReplyDate: data.lastReplyDate.present
          ? data.lastReplyDate.value
          : this.lastReplyDate,
      lastReplyDateAgo: data.lastReplyDateAgo.present
          ? data.lastReplyDateAgo.value
          : this.lastReplyDateAgo,
      lastReplyUsername: data.lastReplyUsername.present
          ? data.lastReplyUsername.value
          : this.lastReplyUsername,
      nodeTitle: data.nodeTitle.present ? data.nodeTitle.value : this.nodeTitle,
      nodeName: data.nodeName.present ? data.nodeName.value : this.nodeName,
      memberAvatar: data.memberAvatar.present
          ? data.memberAvatar.value
          : this.memberAvatar,
      memberUsername: data.memberUsername.present
          ? data.memberUsername.value
          : this.memberUsername,
      replyCount:
          data.replyCount.present ? data.replyCount.value : this.replyCount,
      clickCount:
          data.clickCount.present ? data.clickCount.value : this.clickCount,
      thankCount:
          data.thankCount.present ? data.thankCount.value : this.thankCount,
      collectCount: data.collectCount.present
          ? data.collectCount.value
          : this.collectCount,
      isTop: data.isTop.present ? data.isTop.value : this.isTop,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      isIgnore: data.isIgnore.present ? data.isIgnore.value : this.isIgnore,
      isThanked: data.isThanked.present ? data.isThanked.value : this.isThanked,
      isReport: data.isReport.present ? data.isReport.value : this.isReport,
      isAppend: data.isAppend.present ? data.isAppend.value : this.isAppend,
      isEdit: data.isEdit.present ? data.isEdit.value : this.isEdit,
      isMove: data.isMove.present ? data.isMove.value : this.isMove,
      createdTime:
          data.createdTime.present ? data.createdTime.value : this.createdTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbPostData(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('title: $title, ')
          ..write('contentRendered: $contentRendered, ')
          ..write('contentText: $contentText, ')
          ..write('createDate: $createDate, ')
          ..write('createDateAgo: $createDateAgo, ')
          ..write('lastReplyDate: $lastReplyDate, ')
          ..write('lastReplyDateAgo: $lastReplyDateAgo, ')
          ..write('lastReplyUsername: $lastReplyUsername, ')
          ..write('nodeTitle: $nodeTitle, ')
          ..write('nodeName: $nodeName, ')
          ..write('memberAvatar: $memberAvatar, ')
          ..write('memberUsername: $memberUsername, ')
          ..write('replyCount: $replyCount, ')
          ..write('clickCount: $clickCount, ')
          ..write('thankCount: $thankCount, ')
          ..write('collectCount: $collectCount, ')
          ..write('isTop: $isTop, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isIgnore: $isIgnore, ')
          ..write('isThanked: $isThanked, ')
          ..write('isReport: $isReport, ')
          ..write('isAppend: $isAppend, ')
          ..write('isEdit: $isEdit, ')
          ..write('isMove: $isMove, ')
          ..write('createdTime: $createdTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        postId,
        title,
        contentRendered,
        contentText,
        createDate,
        createDateAgo,
        lastReplyDate,
        lastReplyDateAgo,
        lastReplyUsername,
        nodeTitle,
        nodeName,
        memberAvatar,
        memberUsername,
        replyCount,
        clickCount,
        thankCount,
        collectCount,
        isTop,
        isFavorite,
        isIgnore,
        isThanked,
        isReport,
        isAppend,
        isEdit,
        isMove,
        createdTime
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbPostData &&
          other.id == this.id &&
          other.postId == this.postId &&
          other.title == this.title &&
          other.contentRendered == this.contentRendered &&
          other.contentText == this.contentText &&
          other.createDate == this.createDate &&
          other.createDateAgo == this.createDateAgo &&
          other.lastReplyDate == this.lastReplyDate &&
          other.lastReplyDateAgo == this.lastReplyDateAgo &&
          other.lastReplyUsername == this.lastReplyUsername &&
          other.nodeTitle == this.nodeTitle &&
          other.nodeName == this.nodeName &&
          other.memberAvatar == this.memberAvatar &&
          other.memberUsername == this.memberUsername &&
          other.replyCount == this.replyCount &&
          other.clickCount == this.clickCount &&
          other.thankCount == this.thankCount &&
          other.collectCount == this.collectCount &&
          other.isTop == this.isTop &&
          other.isFavorite == this.isFavorite &&
          other.isIgnore == this.isIgnore &&
          other.isThanked == this.isThanked &&
          other.isReport == this.isReport &&
          other.isAppend == this.isAppend &&
          other.isEdit == this.isEdit &&
          other.isMove == this.isMove &&
          other.createdTime == this.createdTime);
}

class DbPostCompanion extends UpdateCompanion<DbPostData> {
  final Value<int> id;
  final Value<int> postId;
  final Value<String> title;
  final Value<String> contentRendered;
  final Value<String> contentText;
  final Value<String> createDate;
  final Value<String> createDateAgo;
  final Value<String> lastReplyDate;
  final Value<String> lastReplyDateAgo;
  final Value<String> lastReplyUsername;
  final Value<String> nodeTitle;
  final Value<String> nodeName;
  final Value<String> memberAvatar;
  final Value<String> memberUsername;
  final Value<int> replyCount;
  final Value<int> clickCount;
  final Value<int> thankCount;
  final Value<int> collectCount;
  final Value<bool> isTop;
  final Value<bool> isFavorite;
  final Value<bool> isIgnore;
  final Value<bool> isThanked;
  final Value<bool> isReport;
  final Value<bool> isAppend;
  final Value<bool> isEdit;
  final Value<bool> isMove;
  final Value<DateTime> createdTime;
  const DbPostCompanion({
    this.id = const Value.absent(),
    this.postId = const Value.absent(),
    this.title = const Value.absent(),
    this.contentRendered = const Value.absent(),
    this.contentText = const Value.absent(),
    this.createDate = const Value.absent(),
    this.createDateAgo = const Value.absent(),
    this.lastReplyDate = const Value.absent(),
    this.lastReplyDateAgo = const Value.absent(),
    this.lastReplyUsername = const Value.absent(),
    this.nodeTitle = const Value.absent(),
    this.nodeName = const Value.absent(),
    this.memberAvatar = const Value.absent(),
    this.memberUsername = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.clickCount = const Value.absent(),
    this.thankCount = const Value.absent(),
    this.collectCount = const Value.absent(),
    this.isTop = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isIgnore = const Value.absent(),
    this.isThanked = const Value.absent(),
    this.isReport = const Value.absent(),
    this.isAppend = const Value.absent(),
    this.isEdit = const Value.absent(),
    this.isMove = const Value.absent(),
    this.createdTime = const Value.absent(),
  });
  DbPostCompanion.insert({
    this.id = const Value.absent(),
    this.postId = const Value.absent(),
    required String title,
    required String contentRendered,
    required String contentText,
    required String createDate,
    required String createDateAgo,
    required String lastReplyDate,
    required String lastReplyDateAgo,
    required String lastReplyUsername,
    required String nodeTitle,
    required String nodeName,
    required String memberAvatar,
    required String memberUsername,
    this.replyCount = const Value.absent(),
    this.clickCount = const Value.absent(),
    this.thankCount = const Value.absent(),
    this.collectCount = const Value.absent(),
    this.isTop = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isIgnore = const Value.absent(),
    this.isThanked = const Value.absent(),
    this.isReport = const Value.absent(),
    this.isAppend = const Value.absent(),
    this.isEdit = const Value.absent(),
    this.isMove = const Value.absent(),
    this.createdTime = const Value.absent(),
  })  : title = Value(title),
        contentRendered = Value(contentRendered),
        contentText = Value(contentText),
        createDate = Value(createDate),
        createDateAgo = Value(createDateAgo),
        lastReplyDate = Value(lastReplyDate),
        lastReplyDateAgo = Value(lastReplyDateAgo),
        lastReplyUsername = Value(lastReplyUsername),
        nodeTitle = Value(nodeTitle),
        nodeName = Value(nodeName),
        memberAvatar = Value(memberAvatar),
        memberUsername = Value(memberUsername);
  static Insertable<DbPostData> custom({
    Expression<int>? id,
    Expression<int>? postId,
    Expression<String>? title,
    Expression<String>? contentRendered,
    Expression<String>? contentText,
    Expression<String>? createDate,
    Expression<String>? createDateAgo,
    Expression<String>? lastReplyDate,
    Expression<String>? lastReplyDateAgo,
    Expression<String>? lastReplyUsername,
    Expression<String>? nodeTitle,
    Expression<String>? nodeName,
    Expression<String>? memberAvatar,
    Expression<String>? memberUsername,
    Expression<int>? replyCount,
    Expression<int>? clickCount,
    Expression<int>? thankCount,
    Expression<int>? collectCount,
    Expression<bool>? isTop,
    Expression<bool>? isFavorite,
    Expression<bool>? isIgnore,
    Expression<bool>? isThanked,
    Expression<bool>? isReport,
    Expression<bool>? isAppend,
    Expression<bool>? isEdit,
    Expression<bool>? isMove,
    Expression<DateTime>? createdTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (postId != null) 'post_id': postId,
      if (title != null) 'title': title,
      if (contentRendered != null) 'content_rendered': contentRendered,
      if (contentText != null) 'content_text': contentText,
      if (createDate != null) 'create_date': createDate,
      if (createDateAgo != null) 'create_date_ago': createDateAgo,
      if (lastReplyDate != null) 'last_reply_date': lastReplyDate,
      if (lastReplyDateAgo != null) 'last_reply_date_ago': lastReplyDateAgo,
      if (lastReplyUsername != null) 'last_reply_username': lastReplyUsername,
      if (nodeTitle != null) 'node_title': nodeTitle,
      if (nodeName != null) 'node_name': nodeName,
      if (memberAvatar != null) 'member_avatar': memberAvatar,
      if (memberUsername != null) 'member_username': memberUsername,
      if (replyCount != null) 'reply_count': replyCount,
      if (clickCount != null) 'click_count': clickCount,
      if (thankCount != null) 'thank_count': thankCount,
      if (collectCount != null) 'collect_count': collectCount,
      if (isTop != null) 'is_top': isTop,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isIgnore != null) 'is_ignore': isIgnore,
      if (isThanked != null) 'is_thanked': isThanked,
      if (isReport != null) 'is_report': isReport,
      if (isAppend != null) 'is_append': isAppend,
      if (isEdit != null) 'is_edit': isEdit,
      if (isMove != null) 'is_move': isMove,
      if (createdTime != null) 'created_time': createdTime,
    });
  }

  DbPostCompanion copyWith(
      {Value<int>? id,
      Value<int>? postId,
      Value<String>? title,
      Value<String>? contentRendered,
      Value<String>? contentText,
      Value<String>? createDate,
      Value<String>? createDateAgo,
      Value<String>? lastReplyDate,
      Value<String>? lastReplyDateAgo,
      Value<String>? lastReplyUsername,
      Value<String>? nodeTitle,
      Value<String>? nodeName,
      Value<String>? memberAvatar,
      Value<String>? memberUsername,
      Value<int>? replyCount,
      Value<int>? clickCount,
      Value<int>? thankCount,
      Value<int>? collectCount,
      Value<bool>? isTop,
      Value<bool>? isFavorite,
      Value<bool>? isIgnore,
      Value<bool>? isThanked,
      Value<bool>? isReport,
      Value<bool>? isAppend,
      Value<bool>? isEdit,
      Value<bool>? isMove,
      Value<DateTime>? createdTime}) {
    return DbPostCompanion(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      title: title ?? this.title,
      contentRendered: contentRendered ?? this.contentRendered,
      contentText: contentText ?? this.contentText,
      createDate: createDate ?? this.createDate,
      createDateAgo: createDateAgo ?? this.createDateAgo,
      lastReplyDate: lastReplyDate ?? this.lastReplyDate,
      lastReplyDateAgo: lastReplyDateAgo ?? this.lastReplyDateAgo,
      lastReplyUsername: lastReplyUsername ?? this.lastReplyUsername,
      nodeTitle: nodeTitle ?? this.nodeTitle,
      nodeName: nodeName ?? this.nodeName,
      memberAvatar: memberAvatar ?? this.memberAvatar,
      memberUsername: memberUsername ?? this.memberUsername,
      replyCount: replyCount ?? this.replyCount,
      clickCount: clickCount ?? this.clickCount,
      thankCount: thankCount ?? this.thankCount,
      collectCount: collectCount ?? this.collectCount,
      isTop: isTop ?? this.isTop,
      isFavorite: isFavorite ?? this.isFavorite,
      isIgnore: isIgnore ?? this.isIgnore,
      isThanked: isThanked ?? this.isThanked,
      isReport: isReport ?? this.isReport,
      isAppend: isAppend ?? this.isAppend,
      isEdit: isEdit ?? this.isEdit,
      isMove: isMove ?? this.isMove,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (postId.present) {
      map['post_id'] = Variable<int>(postId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (contentRendered.present) {
      map['content_rendered'] = Variable<String>(contentRendered.value);
    }
    if (contentText.present) {
      map['content_text'] = Variable<String>(contentText.value);
    }
    if (createDate.present) {
      map['create_date'] = Variable<String>(createDate.value);
    }
    if (createDateAgo.present) {
      map['create_date_ago'] = Variable<String>(createDateAgo.value);
    }
    if (lastReplyDate.present) {
      map['last_reply_date'] = Variable<String>(lastReplyDate.value);
    }
    if (lastReplyDateAgo.present) {
      map['last_reply_date_ago'] = Variable<String>(lastReplyDateAgo.value);
    }
    if (lastReplyUsername.present) {
      map['last_reply_username'] = Variable<String>(lastReplyUsername.value);
    }
    if (nodeTitle.present) {
      map['node_title'] = Variable<String>(nodeTitle.value);
    }
    if (nodeName.present) {
      map['node_name'] = Variable<String>(nodeName.value);
    }
    if (memberAvatar.present) {
      map['member_avatar'] = Variable<String>(memberAvatar.value);
    }
    if (memberUsername.present) {
      map['member_username'] = Variable<String>(memberUsername.value);
    }
    if (replyCount.present) {
      map['reply_count'] = Variable<int>(replyCount.value);
    }
    if (clickCount.present) {
      map['click_count'] = Variable<int>(clickCount.value);
    }
    if (thankCount.present) {
      map['thank_count'] = Variable<int>(thankCount.value);
    }
    if (collectCount.present) {
      map['collect_count'] = Variable<int>(collectCount.value);
    }
    if (isTop.present) {
      map['is_top'] = Variable<bool>(isTop.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isIgnore.present) {
      map['is_ignore'] = Variable<bool>(isIgnore.value);
    }
    if (isThanked.present) {
      map['is_thanked'] = Variable<bool>(isThanked.value);
    }
    if (isReport.present) {
      map['is_report'] = Variable<bool>(isReport.value);
    }
    if (isAppend.present) {
      map['is_append'] = Variable<bool>(isAppend.value);
    }
    if (isEdit.present) {
      map['is_edit'] = Variable<bool>(isEdit.value);
    }
    if (isMove.present) {
      map['is_move'] = Variable<bool>(isMove.value);
    }
    if (createdTime.present) {
      map['created_time'] = Variable<DateTime>(createdTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbPostCompanion(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('title: $title, ')
          ..write('contentRendered: $contentRendered, ')
          ..write('contentText: $contentText, ')
          ..write('createDate: $createDate, ')
          ..write('createDateAgo: $createDateAgo, ')
          ..write('lastReplyDate: $lastReplyDate, ')
          ..write('lastReplyDateAgo: $lastReplyDateAgo, ')
          ..write('lastReplyUsername: $lastReplyUsername, ')
          ..write('nodeTitle: $nodeTitle, ')
          ..write('nodeName: $nodeName, ')
          ..write('memberAvatar: $memberAvatar, ')
          ..write('memberUsername: $memberUsername, ')
          ..write('replyCount: $replyCount, ')
          ..write('clickCount: $clickCount, ')
          ..write('thankCount: $thankCount, ')
          ..write('collectCount: $collectCount, ')
          ..write('isTop: $isTop, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isIgnore: $isIgnore, ')
          ..write('isThanked: $isThanked, ')
          ..write('isReport: $isReport, ')
          ..write('isAppend: $isAppend, ')
          ..write('isEdit: $isEdit, ')
          ..write('isMove: $isMove, ')
          ..write('createdTime: $createdTime')
          ..write(')'))
        .toString();
  }
}

class $DbReplyTable extends DbReply with TableInfo<$DbReplyTable, DbReplyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbReplyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _postAutoIdMeta =
      const VerificationMeta('postAutoId');
  @override
  late final GeneratedColumn<int> postAutoId = GeneratedColumn<int>(
      'post_auto_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES dbPost(id)');
  static const VerificationMeta _replyIdMeta =
      const VerificationMeta('replyId');
  @override
  late final GeneratedColumn<int> replyId = GeneratedColumn<int>(
      'reply_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _replyContentMeta =
      const VerificationMeta('replyContent');
  @override
  late final GeneratedColumn<String> replyContent = GeneratedColumn<String>(
      'reply_content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _replyUsersMeta =
      const VerificationMeta('replyUsers');
  @override
  late final GeneratedColumn<String> replyUsers = GeneratedColumn<String>(
      'reply_users', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _replyTextMeta =
      const VerificationMeta('replyText');
  @override
  late final GeneratedColumn<String> replyText = GeneratedColumn<String>(
      'reply_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _platformMeta =
      const VerificationMeta('platform');
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
      'platform', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _floorMeta = const VerificationMeta('floor');
  @override
  late final GeneratedColumn<int> floor = GeneratedColumn<int>(
      'floor', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _thankCountMeta =
      const VerificationMeta('thankCount');
  @override
  late final GeneratedColumn<int> thankCount = GeneratedColumn<int>(
      'thank_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _replyCountMeta =
      const VerificationMeta('replyCount');
  @override
  late final GeneratedColumn<int> replyCount = GeneratedColumn<int>(
      'reply_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _replyFloorMeta =
      const VerificationMeta('replyFloor');
  @override
  late final GeneratedColumn<int> replyFloor = GeneratedColumn<int>(
      'reply_floor', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _isThankedMeta =
      const VerificationMeta('isThanked');
  @override
  late final GeneratedColumn<bool> isThanked = GeneratedColumn<bool>(
      'is_thanked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_thanked" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isOpMeta = const VerificationMeta('isOp');
  @override
  late final GeneratedColumn<bool> isOp = GeneratedColumn<bool>(
      'is_op', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_op" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isDupMeta = const VerificationMeta('isDup');
  @override
  late final GeneratedColumn<bool> isDup = GeneratedColumn<bool>(
      'is_dup', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_dup" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isModMeta = const VerificationMeta('isMod');
  @override
  late final GeneratedColumn<bool> isMod = GeneratedColumn<bool>(
      'is_mod', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_mod" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isUseMeta = const VerificationMeta('isUse');
  @override
  late final GeneratedColumn<bool> isUse = GeneratedColumn<bool>(
      'is_use', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_use" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isChooseMeta =
      const VerificationMeta('isChoose');
  @override
  late final GeneratedColumn<bool> isChoose = GeneratedColumn<bool>(
      'is_choose', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_choose" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isWrongMeta =
      const VerificationMeta('isWrong');
  @override
  late final GeneratedColumn<bool> isWrong = GeneratedColumn<bool>(
      'is_wrong', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_wrong" IN (0, 1))'),
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        postAutoId,
        replyId,
        replyContent,
        replyUsers,
        replyText,
        date,
        platform,
        avatar,
        username,
        level,
        floor,
        thankCount,
        replyCount,
        replyFloor,
        isThanked,
        isOp,
        isDup,
        isMod,
        isUse,
        isChoose,
        isWrong
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_reply';
  @override
  VerificationContext validateIntegrity(Insertable<DbReplyData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('post_auto_id')) {
      context.handle(
          _postAutoIdMeta,
          postAutoId.isAcceptableOrUnknown(
              data['post_auto_id']!, _postAutoIdMeta));
    } else if (isInserting) {
      context.missing(_postAutoIdMeta);
    }
    if (data.containsKey('reply_id')) {
      context.handle(_replyIdMeta,
          replyId.isAcceptableOrUnknown(data['reply_id']!, _replyIdMeta));
    }
    if (data.containsKey('reply_content')) {
      context.handle(
          _replyContentMeta,
          replyContent.isAcceptableOrUnknown(
              data['reply_content']!, _replyContentMeta));
    } else if (isInserting) {
      context.missing(_replyContentMeta);
    }
    if (data.containsKey('reply_users')) {
      context.handle(
          _replyUsersMeta,
          replyUsers.isAcceptableOrUnknown(
              data['reply_users']!, _replyUsersMeta));
    } else if (isInserting) {
      context.missing(_replyUsersMeta);
    }
    if (data.containsKey('reply_text')) {
      context.handle(_replyTextMeta,
          replyText.isAcceptableOrUnknown(data['reply_text']!, _replyTextMeta));
    } else if (isInserting) {
      context.missing(_replyTextMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(_platformMeta,
          platform.isAcceptableOrUnknown(data['platform']!, _platformMeta));
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    } else if (isInserting) {
      context.missing(_avatarMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('floor')) {
      context.handle(
          _floorMeta, floor.isAcceptableOrUnknown(data['floor']!, _floorMeta));
    }
    if (data.containsKey('thank_count')) {
      context.handle(
          _thankCountMeta,
          thankCount.isAcceptableOrUnknown(
              data['thank_count']!, _thankCountMeta));
    }
    if (data.containsKey('reply_count')) {
      context.handle(
          _replyCountMeta,
          replyCount.isAcceptableOrUnknown(
              data['reply_count']!, _replyCountMeta));
    }
    if (data.containsKey('reply_floor')) {
      context.handle(
          _replyFloorMeta,
          replyFloor.isAcceptableOrUnknown(
              data['reply_floor']!, _replyFloorMeta));
    }
    if (data.containsKey('is_thanked')) {
      context.handle(_isThankedMeta,
          isThanked.isAcceptableOrUnknown(data['is_thanked']!, _isThankedMeta));
    }
    if (data.containsKey('is_op')) {
      context.handle(
          _isOpMeta, isOp.isAcceptableOrUnknown(data['is_op']!, _isOpMeta));
    }
    if (data.containsKey('is_dup')) {
      context.handle(
          _isDupMeta, isDup.isAcceptableOrUnknown(data['is_dup']!, _isDupMeta));
    }
    if (data.containsKey('is_mod')) {
      context.handle(
          _isModMeta, isMod.isAcceptableOrUnknown(data['is_mod']!, _isModMeta));
    }
    if (data.containsKey('is_use')) {
      context.handle(
          _isUseMeta, isUse.isAcceptableOrUnknown(data['is_use']!, _isUseMeta));
    }
    if (data.containsKey('is_choose')) {
      context.handle(_isChooseMeta,
          isChoose.isAcceptableOrUnknown(data['is_choose']!, _isChooseMeta));
    }
    if (data.containsKey('is_wrong')) {
      context.handle(_isWrongMeta,
          isWrong.isAcceptableOrUnknown(data['is_wrong']!, _isWrongMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbReplyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbReplyData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      postAutoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}post_auto_id'])!,
      replyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reply_id'])!,
      replyContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reply_content'])!,
      replyUsers: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reply_users'])!,
      replyText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reply_text'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      platform: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}platform'])!,
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      floor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}floor'])!,
      thankCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}thank_count'])!,
      replyCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reply_count'])!,
      replyFloor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reply_floor'])!,
      isThanked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_thanked'])!,
      isOp: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_op'])!,
      isDup: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dup'])!,
      isMod: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_mod'])!,
      isUse: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_use'])!,
      isChoose: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_choose'])!,
      isWrong: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_wrong'])!,
    );
  }

  @override
  $DbReplyTable createAlias(String alias) {
    return $DbReplyTable(attachedDatabase, alias);
  }
}

class DbReplyData extends DataClass implements Insertable<DbReplyData> {
  final int id;
  final int postAutoId;
  final int replyId;
  final String replyContent;
  final String replyUsers;
  final String replyText;
  final String date;
  final String platform;
  final String avatar;
  final String username;
  final int level;
  final int floor;
  final int thankCount;
  final int replyCount;
  final int replyFloor;
  final bool isThanked;
  final bool isOp;
  final bool isDup;
  final bool isMod;
  final bool isUse;
  final bool isChoose;
  final bool isWrong;
  const DbReplyData(
      {required this.id,
      required this.postAutoId,
      required this.replyId,
      required this.replyContent,
      required this.replyUsers,
      required this.replyText,
      required this.date,
      required this.platform,
      required this.avatar,
      required this.username,
      required this.level,
      required this.floor,
      required this.thankCount,
      required this.replyCount,
      required this.replyFloor,
      required this.isThanked,
      required this.isOp,
      required this.isDup,
      required this.isMod,
      required this.isUse,
      required this.isChoose,
      required this.isWrong});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['post_auto_id'] = Variable<int>(postAutoId);
    map['reply_id'] = Variable<int>(replyId);
    map['reply_content'] = Variable<String>(replyContent);
    map['reply_users'] = Variable<String>(replyUsers);
    map['reply_text'] = Variable<String>(replyText);
    map['date'] = Variable<String>(date);
    map['platform'] = Variable<String>(platform);
    map['avatar'] = Variable<String>(avatar);
    map['username'] = Variable<String>(username);
    map['level'] = Variable<int>(level);
    map['floor'] = Variable<int>(floor);
    map['thank_count'] = Variable<int>(thankCount);
    map['reply_count'] = Variable<int>(replyCount);
    map['reply_floor'] = Variable<int>(replyFloor);
    map['is_thanked'] = Variable<bool>(isThanked);
    map['is_op'] = Variable<bool>(isOp);
    map['is_dup'] = Variable<bool>(isDup);
    map['is_mod'] = Variable<bool>(isMod);
    map['is_use'] = Variable<bool>(isUse);
    map['is_choose'] = Variable<bool>(isChoose);
    map['is_wrong'] = Variable<bool>(isWrong);
    return map;
  }

  DbReplyCompanion toCompanion(bool nullToAbsent) {
    return DbReplyCompanion(
      id: Value(id),
      postAutoId: Value(postAutoId),
      replyId: Value(replyId),
      replyContent: Value(replyContent),
      replyUsers: Value(replyUsers),
      replyText: Value(replyText),
      date: Value(date),
      platform: Value(platform),
      avatar: Value(avatar),
      username: Value(username),
      level: Value(level),
      floor: Value(floor),
      thankCount: Value(thankCount),
      replyCount: Value(replyCount),
      replyFloor: Value(replyFloor),
      isThanked: Value(isThanked),
      isOp: Value(isOp),
      isDup: Value(isDup),
      isMod: Value(isMod),
      isUse: Value(isUse),
      isChoose: Value(isChoose),
      isWrong: Value(isWrong),
    );
  }

  factory DbReplyData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbReplyData(
      id: serializer.fromJson<int>(json['id']),
      postAutoId: serializer.fromJson<int>(json['postAutoId']),
      replyId: serializer.fromJson<int>(json['replyId']),
      replyContent: serializer.fromJson<String>(json['replyContent']),
      replyUsers: serializer.fromJson<String>(json['replyUsers']),
      replyText: serializer.fromJson<String>(json['replyText']),
      date: serializer.fromJson<String>(json['date']),
      platform: serializer.fromJson<String>(json['platform']),
      avatar: serializer.fromJson<String>(json['avatar']),
      username: serializer.fromJson<String>(json['username']),
      level: serializer.fromJson<int>(json['level']),
      floor: serializer.fromJson<int>(json['floor']),
      thankCount: serializer.fromJson<int>(json['thankCount']),
      replyCount: serializer.fromJson<int>(json['replyCount']),
      replyFloor: serializer.fromJson<int>(json['replyFloor']),
      isThanked: serializer.fromJson<bool>(json['isThanked']),
      isOp: serializer.fromJson<bool>(json['isOp']),
      isDup: serializer.fromJson<bool>(json['isDup']),
      isMod: serializer.fromJson<bool>(json['isMod']),
      isUse: serializer.fromJson<bool>(json['isUse']),
      isChoose: serializer.fromJson<bool>(json['isChoose']),
      isWrong: serializer.fromJson<bool>(json['isWrong']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'postAutoId': serializer.toJson<int>(postAutoId),
      'replyId': serializer.toJson<int>(replyId),
      'replyContent': serializer.toJson<String>(replyContent),
      'replyUsers': serializer.toJson<String>(replyUsers),
      'replyText': serializer.toJson<String>(replyText),
      'date': serializer.toJson<String>(date),
      'platform': serializer.toJson<String>(platform),
      'avatar': serializer.toJson<String>(avatar),
      'username': serializer.toJson<String>(username),
      'level': serializer.toJson<int>(level),
      'floor': serializer.toJson<int>(floor),
      'thankCount': serializer.toJson<int>(thankCount),
      'replyCount': serializer.toJson<int>(replyCount),
      'replyFloor': serializer.toJson<int>(replyFloor),
      'isThanked': serializer.toJson<bool>(isThanked),
      'isOp': serializer.toJson<bool>(isOp),
      'isDup': serializer.toJson<bool>(isDup),
      'isMod': serializer.toJson<bool>(isMod),
      'isUse': serializer.toJson<bool>(isUse),
      'isChoose': serializer.toJson<bool>(isChoose),
      'isWrong': serializer.toJson<bool>(isWrong),
    };
  }

  DbReplyData copyWith(
          {int? id,
          int? postAutoId,
          int? replyId,
          String? replyContent,
          String? replyUsers,
          String? replyText,
          String? date,
          String? platform,
          String? avatar,
          String? username,
          int? level,
          int? floor,
          int? thankCount,
          int? replyCount,
          int? replyFloor,
          bool? isThanked,
          bool? isOp,
          bool? isDup,
          bool? isMod,
          bool? isUse,
          bool? isChoose,
          bool? isWrong}) =>
      DbReplyData(
        id: id ?? this.id,
        postAutoId: postAutoId ?? this.postAutoId,
        replyId: replyId ?? this.replyId,
        replyContent: replyContent ?? this.replyContent,
        replyUsers: replyUsers ?? this.replyUsers,
        replyText: replyText ?? this.replyText,
        date: date ?? this.date,
        platform: platform ?? this.platform,
        avatar: avatar ?? this.avatar,
        username: username ?? this.username,
        level: level ?? this.level,
        floor: floor ?? this.floor,
        thankCount: thankCount ?? this.thankCount,
        replyCount: replyCount ?? this.replyCount,
        replyFloor: replyFloor ?? this.replyFloor,
        isThanked: isThanked ?? this.isThanked,
        isOp: isOp ?? this.isOp,
        isDup: isDup ?? this.isDup,
        isMod: isMod ?? this.isMod,
        isUse: isUse ?? this.isUse,
        isChoose: isChoose ?? this.isChoose,
        isWrong: isWrong ?? this.isWrong,
      );
  DbReplyData copyWithCompanion(DbReplyCompanion data) {
    return DbReplyData(
      id: data.id.present ? data.id.value : this.id,
      postAutoId:
          data.postAutoId.present ? data.postAutoId.value : this.postAutoId,
      replyId: data.replyId.present ? data.replyId.value : this.replyId,
      replyContent: data.replyContent.present
          ? data.replyContent.value
          : this.replyContent,
      replyUsers:
          data.replyUsers.present ? data.replyUsers.value : this.replyUsers,
      replyText: data.replyText.present ? data.replyText.value : this.replyText,
      date: data.date.present ? data.date.value : this.date,
      platform: data.platform.present ? data.platform.value : this.platform,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      username: data.username.present ? data.username.value : this.username,
      level: data.level.present ? data.level.value : this.level,
      floor: data.floor.present ? data.floor.value : this.floor,
      thankCount:
          data.thankCount.present ? data.thankCount.value : this.thankCount,
      replyCount:
          data.replyCount.present ? data.replyCount.value : this.replyCount,
      replyFloor:
          data.replyFloor.present ? data.replyFloor.value : this.replyFloor,
      isThanked: data.isThanked.present ? data.isThanked.value : this.isThanked,
      isOp: data.isOp.present ? data.isOp.value : this.isOp,
      isDup: data.isDup.present ? data.isDup.value : this.isDup,
      isMod: data.isMod.present ? data.isMod.value : this.isMod,
      isUse: data.isUse.present ? data.isUse.value : this.isUse,
      isChoose: data.isChoose.present ? data.isChoose.value : this.isChoose,
      isWrong: data.isWrong.present ? data.isWrong.value : this.isWrong,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbReplyData(')
          ..write('id: $id, ')
          ..write('postAutoId: $postAutoId, ')
          ..write('replyId: $replyId, ')
          ..write('replyContent: $replyContent, ')
          ..write('replyUsers: $replyUsers, ')
          ..write('replyText: $replyText, ')
          ..write('date: $date, ')
          ..write('platform: $platform, ')
          ..write('avatar: $avatar, ')
          ..write('username: $username, ')
          ..write('level: $level, ')
          ..write('floor: $floor, ')
          ..write('thankCount: $thankCount, ')
          ..write('replyCount: $replyCount, ')
          ..write('replyFloor: $replyFloor, ')
          ..write('isThanked: $isThanked, ')
          ..write('isOp: $isOp, ')
          ..write('isDup: $isDup, ')
          ..write('isMod: $isMod, ')
          ..write('isUse: $isUse, ')
          ..write('isChoose: $isChoose, ')
          ..write('isWrong: $isWrong')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        postAutoId,
        replyId,
        replyContent,
        replyUsers,
        replyText,
        date,
        platform,
        avatar,
        username,
        level,
        floor,
        thankCount,
        replyCount,
        replyFloor,
        isThanked,
        isOp,
        isDup,
        isMod,
        isUse,
        isChoose,
        isWrong
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbReplyData &&
          other.id == this.id &&
          other.postAutoId == this.postAutoId &&
          other.replyId == this.replyId &&
          other.replyContent == this.replyContent &&
          other.replyUsers == this.replyUsers &&
          other.replyText == this.replyText &&
          other.date == this.date &&
          other.platform == this.platform &&
          other.avatar == this.avatar &&
          other.username == this.username &&
          other.level == this.level &&
          other.floor == this.floor &&
          other.thankCount == this.thankCount &&
          other.replyCount == this.replyCount &&
          other.replyFloor == this.replyFloor &&
          other.isThanked == this.isThanked &&
          other.isOp == this.isOp &&
          other.isDup == this.isDup &&
          other.isMod == this.isMod &&
          other.isUse == this.isUse &&
          other.isChoose == this.isChoose &&
          other.isWrong == this.isWrong);
}

class DbReplyCompanion extends UpdateCompanion<DbReplyData> {
  final Value<int> id;
  final Value<int> postAutoId;
  final Value<int> replyId;
  final Value<String> replyContent;
  final Value<String> replyUsers;
  final Value<String> replyText;
  final Value<String> date;
  final Value<String> platform;
  final Value<String> avatar;
  final Value<String> username;
  final Value<int> level;
  final Value<int> floor;
  final Value<int> thankCount;
  final Value<int> replyCount;
  final Value<int> replyFloor;
  final Value<bool> isThanked;
  final Value<bool> isOp;
  final Value<bool> isDup;
  final Value<bool> isMod;
  final Value<bool> isUse;
  final Value<bool> isChoose;
  final Value<bool> isWrong;
  const DbReplyCompanion({
    this.id = const Value.absent(),
    this.postAutoId = const Value.absent(),
    this.replyId = const Value.absent(),
    this.replyContent = const Value.absent(),
    this.replyUsers = const Value.absent(),
    this.replyText = const Value.absent(),
    this.date = const Value.absent(),
    this.platform = const Value.absent(),
    this.avatar = const Value.absent(),
    this.username = const Value.absent(),
    this.level = const Value.absent(),
    this.floor = const Value.absent(),
    this.thankCount = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.replyFloor = const Value.absent(),
    this.isThanked = const Value.absent(),
    this.isOp = const Value.absent(),
    this.isDup = const Value.absent(),
    this.isMod = const Value.absent(),
    this.isUse = const Value.absent(),
    this.isChoose = const Value.absent(),
    this.isWrong = const Value.absent(),
  });
  DbReplyCompanion.insert({
    this.id = const Value.absent(),
    required int postAutoId,
    this.replyId = const Value.absent(),
    required String replyContent,
    required String replyUsers,
    required String replyText,
    required String date,
    required String platform,
    required String avatar,
    required String username,
    this.level = const Value.absent(),
    this.floor = const Value.absent(),
    this.thankCount = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.replyFloor = const Value.absent(),
    this.isThanked = const Value.absent(),
    this.isOp = const Value.absent(),
    this.isDup = const Value.absent(),
    this.isMod = const Value.absent(),
    this.isUse = const Value.absent(),
    this.isChoose = const Value.absent(),
    this.isWrong = const Value.absent(),
  })  : postAutoId = Value(postAutoId),
        replyContent = Value(replyContent),
        replyUsers = Value(replyUsers),
        replyText = Value(replyText),
        date = Value(date),
        platform = Value(platform),
        avatar = Value(avatar),
        username = Value(username);
  static Insertable<DbReplyData> custom({
    Expression<int>? id,
    Expression<int>? postAutoId,
    Expression<int>? replyId,
    Expression<String>? replyContent,
    Expression<String>? replyUsers,
    Expression<String>? replyText,
    Expression<String>? date,
    Expression<String>? platform,
    Expression<String>? avatar,
    Expression<String>? username,
    Expression<int>? level,
    Expression<int>? floor,
    Expression<int>? thankCount,
    Expression<int>? replyCount,
    Expression<int>? replyFloor,
    Expression<bool>? isThanked,
    Expression<bool>? isOp,
    Expression<bool>? isDup,
    Expression<bool>? isMod,
    Expression<bool>? isUse,
    Expression<bool>? isChoose,
    Expression<bool>? isWrong,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (postAutoId != null) 'post_auto_id': postAutoId,
      if (replyId != null) 'reply_id': replyId,
      if (replyContent != null) 'reply_content': replyContent,
      if (replyUsers != null) 'reply_users': replyUsers,
      if (replyText != null) 'reply_text': replyText,
      if (date != null) 'date': date,
      if (platform != null) 'platform': platform,
      if (avatar != null) 'avatar': avatar,
      if (username != null) 'username': username,
      if (level != null) 'level': level,
      if (floor != null) 'floor': floor,
      if (thankCount != null) 'thank_count': thankCount,
      if (replyCount != null) 'reply_count': replyCount,
      if (replyFloor != null) 'reply_floor': replyFloor,
      if (isThanked != null) 'is_thanked': isThanked,
      if (isOp != null) 'is_op': isOp,
      if (isDup != null) 'is_dup': isDup,
      if (isMod != null) 'is_mod': isMod,
      if (isUse != null) 'is_use': isUse,
      if (isChoose != null) 'is_choose': isChoose,
      if (isWrong != null) 'is_wrong': isWrong,
    });
  }

  DbReplyCompanion copyWith(
      {Value<int>? id,
      Value<int>? postAutoId,
      Value<int>? replyId,
      Value<String>? replyContent,
      Value<String>? replyUsers,
      Value<String>? replyText,
      Value<String>? date,
      Value<String>? platform,
      Value<String>? avatar,
      Value<String>? username,
      Value<int>? level,
      Value<int>? floor,
      Value<int>? thankCount,
      Value<int>? replyCount,
      Value<int>? replyFloor,
      Value<bool>? isThanked,
      Value<bool>? isOp,
      Value<bool>? isDup,
      Value<bool>? isMod,
      Value<bool>? isUse,
      Value<bool>? isChoose,
      Value<bool>? isWrong}) {
    return DbReplyCompanion(
      id: id ?? this.id,
      postAutoId: postAutoId ?? this.postAutoId,
      replyId: replyId ?? this.replyId,
      replyContent: replyContent ?? this.replyContent,
      replyUsers: replyUsers ?? this.replyUsers,
      replyText: replyText ?? this.replyText,
      date: date ?? this.date,
      platform: platform ?? this.platform,
      avatar: avatar ?? this.avatar,
      username: username ?? this.username,
      level: level ?? this.level,
      floor: floor ?? this.floor,
      thankCount: thankCount ?? this.thankCount,
      replyCount: replyCount ?? this.replyCount,
      replyFloor: replyFloor ?? this.replyFloor,
      isThanked: isThanked ?? this.isThanked,
      isOp: isOp ?? this.isOp,
      isDup: isDup ?? this.isDup,
      isMod: isMod ?? this.isMod,
      isUse: isUse ?? this.isUse,
      isChoose: isChoose ?? this.isChoose,
      isWrong: isWrong ?? this.isWrong,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (postAutoId.present) {
      map['post_auto_id'] = Variable<int>(postAutoId.value);
    }
    if (replyId.present) {
      map['reply_id'] = Variable<int>(replyId.value);
    }
    if (replyContent.present) {
      map['reply_content'] = Variable<String>(replyContent.value);
    }
    if (replyUsers.present) {
      map['reply_users'] = Variable<String>(replyUsers.value);
    }
    if (replyText.present) {
      map['reply_text'] = Variable<String>(replyText.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (floor.present) {
      map['floor'] = Variable<int>(floor.value);
    }
    if (thankCount.present) {
      map['thank_count'] = Variable<int>(thankCount.value);
    }
    if (replyCount.present) {
      map['reply_count'] = Variable<int>(replyCount.value);
    }
    if (replyFloor.present) {
      map['reply_floor'] = Variable<int>(replyFloor.value);
    }
    if (isThanked.present) {
      map['is_thanked'] = Variable<bool>(isThanked.value);
    }
    if (isOp.present) {
      map['is_op'] = Variable<bool>(isOp.value);
    }
    if (isDup.present) {
      map['is_dup'] = Variable<bool>(isDup.value);
    }
    if (isMod.present) {
      map['is_mod'] = Variable<bool>(isMod.value);
    }
    if (isUse.present) {
      map['is_use'] = Variable<bool>(isUse.value);
    }
    if (isChoose.present) {
      map['is_choose'] = Variable<bool>(isChoose.value);
    }
    if (isWrong.present) {
      map['is_wrong'] = Variable<bool>(isWrong.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbReplyCompanion(')
          ..write('id: $id, ')
          ..write('postAutoId: $postAutoId, ')
          ..write('replyId: $replyId, ')
          ..write('replyContent: $replyContent, ')
          ..write('replyUsers: $replyUsers, ')
          ..write('replyText: $replyText, ')
          ..write('date: $date, ')
          ..write('platform: $platform, ')
          ..write('avatar: $avatar, ')
          ..write('username: $username, ')
          ..write('level: $level, ')
          ..write('floor: $floor, ')
          ..write('thankCount: $thankCount, ')
          ..write('replyCount: $replyCount, ')
          ..write('replyFloor: $replyFloor, ')
          ..write('isThanked: $isThanked, ')
          ..write('isOp: $isOp, ')
          ..write('isDup: $isDup, ')
          ..write('isMod: $isMod, ')
          ..write('isUse: $isUse, ')
          ..write('isChoose: $isChoose, ')
          ..write('isWrong: $isWrong')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DbPostTable dbPost = $DbPostTable(this);
  late final $DbReplyTable dbReply = $DbReplyTable(this);
  late final PostDao postDao = PostDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [dbPost, dbReply];
}

typedef $$DbPostTableCreateCompanionBuilder = DbPostCompanion Function({
  Value<int> id,
  Value<int> postId,
  required String title,
  required String contentRendered,
  required String contentText,
  required String createDate,
  required String createDateAgo,
  required String lastReplyDate,
  required String lastReplyDateAgo,
  required String lastReplyUsername,
  required String nodeTitle,
  required String nodeName,
  required String memberAvatar,
  required String memberUsername,
  Value<int> replyCount,
  Value<int> clickCount,
  Value<int> thankCount,
  Value<int> collectCount,
  Value<bool> isTop,
  Value<bool> isFavorite,
  Value<bool> isIgnore,
  Value<bool> isThanked,
  Value<bool> isReport,
  Value<bool> isAppend,
  Value<bool> isEdit,
  Value<bool> isMove,
  Value<DateTime> createdTime,
});
typedef $$DbPostTableUpdateCompanionBuilder = DbPostCompanion Function({
  Value<int> id,
  Value<int> postId,
  Value<String> title,
  Value<String> contentRendered,
  Value<String> contentText,
  Value<String> createDate,
  Value<String> createDateAgo,
  Value<String> lastReplyDate,
  Value<String> lastReplyDateAgo,
  Value<String> lastReplyUsername,
  Value<String> nodeTitle,
  Value<String> nodeName,
  Value<String> memberAvatar,
  Value<String> memberUsername,
  Value<int> replyCount,
  Value<int> clickCount,
  Value<int> thankCount,
  Value<int> collectCount,
  Value<bool> isTop,
  Value<bool> isFavorite,
  Value<bool> isIgnore,
  Value<bool> isThanked,
  Value<bool> isReport,
  Value<bool> isAppend,
  Value<bool> isEdit,
  Value<bool> isMove,
  Value<DateTime> createdTime,
});

class $$DbPostTableFilterComposer
    extends Composer<_$AppDatabase, $DbPostTable> {
  $$DbPostTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get postId => $composableBuilder(
      column: $table.postId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentRendered => $composableBuilder(
      column: $table.contentRendered,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentText => $composableBuilder(
      column: $table.contentText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createDateAgo => $composableBuilder(
      column: $table.createDateAgo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastReplyDate => $composableBuilder(
      column: $table.lastReplyDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastReplyDateAgo => $composableBuilder(
      column: $table.lastReplyDateAgo,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastReplyUsername => $composableBuilder(
      column: $table.lastReplyUsername,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nodeTitle => $composableBuilder(
      column: $table.nodeTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nodeName => $composableBuilder(
      column: $table.nodeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memberAvatar => $composableBuilder(
      column: $table.memberAvatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memberUsername => $composableBuilder(
      column: $table.memberUsername,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get clickCount => $composableBuilder(
      column: $table.clickCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get thankCount => $composableBuilder(
      column: $table.thankCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get collectCount => $composableBuilder(
      column: $table.collectCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isTop => $composableBuilder(
      column: $table.isTop, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isIgnore => $composableBuilder(
      column: $table.isIgnore, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isThanked => $composableBuilder(
      column: $table.isThanked, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isReport => $composableBuilder(
      column: $table.isReport, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAppend => $composableBuilder(
      column: $table.isAppend, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEdit => $composableBuilder(
      column: $table.isEdit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isMove => $composableBuilder(
      column: $table.isMove, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdTime => $composableBuilder(
      column: $table.createdTime, builder: (column) => ColumnFilters(column));
}

class $$DbPostTableOrderingComposer
    extends Composer<_$AppDatabase, $DbPostTable> {
  $$DbPostTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get postId => $composableBuilder(
      column: $table.postId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentRendered => $composableBuilder(
      column: $table.contentRendered,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentText => $composableBuilder(
      column: $table.contentText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createDateAgo => $composableBuilder(
      column: $table.createDateAgo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastReplyDate => $composableBuilder(
      column: $table.lastReplyDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastReplyDateAgo => $composableBuilder(
      column: $table.lastReplyDateAgo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastReplyUsername => $composableBuilder(
      column: $table.lastReplyUsername,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nodeTitle => $composableBuilder(
      column: $table.nodeTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nodeName => $composableBuilder(
      column: $table.nodeName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memberAvatar => $composableBuilder(
      column: $table.memberAvatar,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memberUsername => $composableBuilder(
      column: $table.memberUsername,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get clickCount => $composableBuilder(
      column: $table.clickCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get thankCount => $composableBuilder(
      column: $table.thankCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get collectCount => $composableBuilder(
      column: $table.collectCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isTop => $composableBuilder(
      column: $table.isTop, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isIgnore => $composableBuilder(
      column: $table.isIgnore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isThanked => $composableBuilder(
      column: $table.isThanked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isReport => $composableBuilder(
      column: $table.isReport, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAppend => $composableBuilder(
      column: $table.isAppend, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEdit => $composableBuilder(
      column: $table.isEdit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isMove => $composableBuilder(
      column: $table.isMove, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdTime => $composableBuilder(
      column: $table.createdTime, builder: (column) => ColumnOrderings(column));
}

class $$DbPostTableAnnotationComposer
    extends Composer<_$AppDatabase, $DbPostTable> {
  $$DbPostTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get postId =>
      $composableBuilder(column: $table.postId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get contentRendered => $composableBuilder(
      column: $table.contentRendered, builder: (column) => column);

  GeneratedColumn<String> get contentText => $composableBuilder(
      column: $table.contentText, builder: (column) => column);

  GeneratedColumn<String> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => column);

  GeneratedColumn<String> get createDateAgo => $composableBuilder(
      column: $table.createDateAgo, builder: (column) => column);

  GeneratedColumn<String> get lastReplyDate => $composableBuilder(
      column: $table.lastReplyDate, builder: (column) => column);

  GeneratedColumn<String> get lastReplyDateAgo => $composableBuilder(
      column: $table.lastReplyDateAgo, builder: (column) => column);

  GeneratedColumn<String> get lastReplyUsername => $composableBuilder(
      column: $table.lastReplyUsername, builder: (column) => column);

  GeneratedColumn<String> get nodeTitle =>
      $composableBuilder(column: $table.nodeTitle, builder: (column) => column);

  GeneratedColumn<String> get nodeName =>
      $composableBuilder(column: $table.nodeName, builder: (column) => column);

  GeneratedColumn<String> get memberAvatar => $composableBuilder(
      column: $table.memberAvatar, builder: (column) => column);

  GeneratedColumn<String> get memberUsername => $composableBuilder(
      column: $table.memberUsername, builder: (column) => column);

  GeneratedColumn<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => column);

  GeneratedColumn<int> get clickCount => $composableBuilder(
      column: $table.clickCount, builder: (column) => column);

  GeneratedColumn<int> get thankCount => $composableBuilder(
      column: $table.thankCount, builder: (column) => column);

  GeneratedColumn<int> get collectCount => $composableBuilder(
      column: $table.collectCount, builder: (column) => column);

  GeneratedColumn<bool> get isTop =>
      $composableBuilder(column: $table.isTop, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<bool> get isIgnore =>
      $composableBuilder(column: $table.isIgnore, builder: (column) => column);

  GeneratedColumn<bool> get isThanked =>
      $composableBuilder(column: $table.isThanked, builder: (column) => column);

  GeneratedColumn<bool> get isReport =>
      $composableBuilder(column: $table.isReport, builder: (column) => column);

  GeneratedColumn<bool> get isAppend =>
      $composableBuilder(column: $table.isAppend, builder: (column) => column);

  GeneratedColumn<bool> get isEdit =>
      $composableBuilder(column: $table.isEdit, builder: (column) => column);

  GeneratedColumn<bool> get isMove =>
      $composableBuilder(column: $table.isMove, builder: (column) => column);

  GeneratedColumn<DateTime> get createdTime => $composableBuilder(
      column: $table.createdTime, builder: (column) => column);
}

class $$DbPostTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DbPostTable,
    DbPostData,
    $$DbPostTableFilterComposer,
    $$DbPostTableOrderingComposer,
    $$DbPostTableAnnotationComposer,
    $$DbPostTableCreateCompanionBuilder,
    $$DbPostTableUpdateCompanionBuilder,
    (DbPostData, BaseReferences<_$AppDatabase, $DbPostTable, DbPostData>),
    DbPostData,
    PrefetchHooks Function()> {
  $$DbPostTableTableManager(_$AppDatabase db, $DbPostTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbPostTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbPostTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbPostTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> postId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> contentRendered = const Value.absent(),
            Value<String> contentText = const Value.absent(),
            Value<String> createDate = const Value.absent(),
            Value<String> createDateAgo = const Value.absent(),
            Value<String> lastReplyDate = const Value.absent(),
            Value<String> lastReplyDateAgo = const Value.absent(),
            Value<String> lastReplyUsername = const Value.absent(),
            Value<String> nodeTitle = const Value.absent(),
            Value<String> nodeName = const Value.absent(),
            Value<String> memberAvatar = const Value.absent(),
            Value<String> memberUsername = const Value.absent(),
            Value<int> replyCount = const Value.absent(),
            Value<int> clickCount = const Value.absent(),
            Value<int> thankCount = const Value.absent(),
            Value<int> collectCount = const Value.absent(),
            Value<bool> isTop = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<bool> isIgnore = const Value.absent(),
            Value<bool> isThanked = const Value.absent(),
            Value<bool> isReport = const Value.absent(),
            Value<bool> isAppend = const Value.absent(),
            Value<bool> isEdit = const Value.absent(),
            Value<bool> isMove = const Value.absent(),
            Value<DateTime> createdTime = const Value.absent(),
          }) =>
              DbPostCompanion(
            id: id,
            postId: postId,
            title: title,
            contentRendered: contentRendered,
            contentText: contentText,
            createDate: createDate,
            createDateAgo: createDateAgo,
            lastReplyDate: lastReplyDate,
            lastReplyDateAgo: lastReplyDateAgo,
            lastReplyUsername: lastReplyUsername,
            nodeTitle: nodeTitle,
            nodeName: nodeName,
            memberAvatar: memberAvatar,
            memberUsername: memberUsername,
            replyCount: replyCount,
            clickCount: clickCount,
            thankCount: thankCount,
            collectCount: collectCount,
            isTop: isTop,
            isFavorite: isFavorite,
            isIgnore: isIgnore,
            isThanked: isThanked,
            isReport: isReport,
            isAppend: isAppend,
            isEdit: isEdit,
            isMove: isMove,
            createdTime: createdTime,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> postId = const Value.absent(),
            required String title,
            required String contentRendered,
            required String contentText,
            required String createDate,
            required String createDateAgo,
            required String lastReplyDate,
            required String lastReplyDateAgo,
            required String lastReplyUsername,
            required String nodeTitle,
            required String nodeName,
            required String memberAvatar,
            required String memberUsername,
            Value<int> replyCount = const Value.absent(),
            Value<int> clickCount = const Value.absent(),
            Value<int> thankCount = const Value.absent(),
            Value<int> collectCount = const Value.absent(),
            Value<bool> isTop = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<bool> isIgnore = const Value.absent(),
            Value<bool> isThanked = const Value.absent(),
            Value<bool> isReport = const Value.absent(),
            Value<bool> isAppend = const Value.absent(),
            Value<bool> isEdit = const Value.absent(),
            Value<bool> isMove = const Value.absent(),
            Value<DateTime> createdTime = const Value.absent(),
          }) =>
              DbPostCompanion.insert(
            id: id,
            postId: postId,
            title: title,
            contentRendered: contentRendered,
            contentText: contentText,
            createDate: createDate,
            createDateAgo: createDateAgo,
            lastReplyDate: lastReplyDate,
            lastReplyDateAgo: lastReplyDateAgo,
            lastReplyUsername: lastReplyUsername,
            nodeTitle: nodeTitle,
            nodeName: nodeName,
            memberAvatar: memberAvatar,
            memberUsername: memberUsername,
            replyCount: replyCount,
            clickCount: clickCount,
            thankCount: thankCount,
            collectCount: collectCount,
            isTop: isTop,
            isFavorite: isFavorite,
            isIgnore: isIgnore,
            isThanked: isThanked,
            isReport: isReport,
            isAppend: isAppend,
            isEdit: isEdit,
            isMove: isMove,
            createdTime: createdTime,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DbPostTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DbPostTable,
    DbPostData,
    $$DbPostTableFilterComposer,
    $$DbPostTableOrderingComposer,
    $$DbPostTableAnnotationComposer,
    $$DbPostTableCreateCompanionBuilder,
    $$DbPostTableUpdateCompanionBuilder,
    (DbPostData, BaseReferences<_$AppDatabase, $DbPostTable, DbPostData>),
    DbPostData,
    PrefetchHooks Function()>;
typedef $$DbReplyTableCreateCompanionBuilder = DbReplyCompanion Function({
  Value<int> id,
  required int postAutoId,
  Value<int> replyId,
  required String replyContent,
  required String replyUsers,
  required String replyText,
  required String date,
  required String platform,
  required String avatar,
  required String username,
  Value<int> level,
  Value<int> floor,
  Value<int> thankCount,
  Value<int> replyCount,
  Value<int> replyFloor,
  Value<bool> isThanked,
  Value<bool> isOp,
  Value<bool> isDup,
  Value<bool> isMod,
  Value<bool> isUse,
  Value<bool> isChoose,
  Value<bool> isWrong,
});
typedef $$DbReplyTableUpdateCompanionBuilder = DbReplyCompanion Function({
  Value<int> id,
  Value<int> postAutoId,
  Value<int> replyId,
  Value<String> replyContent,
  Value<String> replyUsers,
  Value<String> replyText,
  Value<String> date,
  Value<String> platform,
  Value<String> avatar,
  Value<String> username,
  Value<int> level,
  Value<int> floor,
  Value<int> thankCount,
  Value<int> replyCount,
  Value<int> replyFloor,
  Value<bool> isThanked,
  Value<bool> isOp,
  Value<bool> isDup,
  Value<bool> isMod,
  Value<bool> isUse,
  Value<bool> isChoose,
  Value<bool> isWrong,
});

class $$DbReplyTableFilterComposer
    extends Composer<_$AppDatabase, $DbReplyTable> {
  $$DbReplyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get postAutoId => $composableBuilder(
      column: $table.postAutoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get replyId => $composableBuilder(
      column: $table.replyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get replyContent => $composableBuilder(
      column: $table.replyContent, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get replyUsers => $composableBuilder(
      column: $table.replyUsers, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get replyText => $composableBuilder(
      column: $table.replyText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get platform => $composableBuilder(
      column: $table.platform, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatar => $composableBuilder(
      column: $table.avatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get floor => $composableBuilder(
      column: $table.floor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get thankCount => $composableBuilder(
      column: $table.thankCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get replyFloor => $composableBuilder(
      column: $table.replyFloor, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isThanked => $composableBuilder(
      column: $table.isThanked, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isOp => $composableBuilder(
      column: $table.isOp, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDup => $composableBuilder(
      column: $table.isDup, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isMod => $composableBuilder(
      column: $table.isMod, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUse => $composableBuilder(
      column: $table.isUse, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isChoose => $composableBuilder(
      column: $table.isChoose, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isWrong => $composableBuilder(
      column: $table.isWrong, builder: (column) => ColumnFilters(column));
}

class $$DbReplyTableOrderingComposer
    extends Composer<_$AppDatabase, $DbReplyTable> {
  $$DbReplyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get postAutoId => $composableBuilder(
      column: $table.postAutoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get replyId => $composableBuilder(
      column: $table.replyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get replyContent => $composableBuilder(
      column: $table.replyContent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get replyUsers => $composableBuilder(
      column: $table.replyUsers, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get replyText => $composableBuilder(
      column: $table.replyText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get platform => $composableBuilder(
      column: $table.platform, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatar => $composableBuilder(
      column: $table.avatar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get floor => $composableBuilder(
      column: $table.floor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get thankCount => $composableBuilder(
      column: $table.thankCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get replyFloor => $composableBuilder(
      column: $table.replyFloor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isThanked => $composableBuilder(
      column: $table.isThanked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOp => $composableBuilder(
      column: $table.isOp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDup => $composableBuilder(
      column: $table.isDup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isMod => $composableBuilder(
      column: $table.isMod, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUse => $composableBuilder(
      column: $table.isUse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isChoose => $composableBuilder(
      column: $table.isChoose, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isWrong => $composableBuilder(
      column: $table.isWrong, builder: (column) => ColumnOrderings(column));
}

class $$DbReplyTableAnnotationComposer
    extends Composer<_$AppDatabase, $DbReplyTable> {
  $$DbReplyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get postAutoId => $composableBuilder(
      column: $table.postAutoId, builder: (column) => column);

  GeneratedColumn<int> get replyId =>
      $composableBuilder(column: $table.replyId, builder: (column) => column);

  GeneratedColumn<String> get replyContent => $composableBuilder(
      column: $table.replyContent, builder: (column) => column);

  GeneratedColumn<String> get replyUsers => $composableBuilder(
      column: $table.replyUsers, builder: (column) => column);

  GeneratedColumn<String> get replyText =>
      $composableBuilder(column: $table.replyText, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get floor =>
      $composableBuilder(column: $table.floor, builder: (column) => column);

  GeneratedColumn<int> get thankCount => $composableBuilder(
      column: $table.thankCount, builder: (column) => column);

  GeneratedColumn<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => column);

  GeneratedColumn<int> get replyFloor => $composableBuilder(
      column: $table.replyFloor, builder: (column) => column);

  GeneratedColumn<bool> get isThanked =>
      $composableBuilder(column: $table.isThanked, builder: (column) => column);

  GeneratedColumn<bool> get isOp =>
      $composableBuilder(column: $table.isOp, builder: (column) => column);

  GeneratedColumn<bool> get isDup =>
      $composableBuilder(column: $table.isDup, builder: (column) => column);

  GeneratedColumn<bool> get isMod =>
      $composableBuilder(column: $table.isMod, builder: (column) => column);

  GeneratedColumn<bool> get isUse =>
      $composableBuilder(column: $table.isUse, builder: (column) => column);

  GeneratedColumn<bool> get isChoose =>
      $composableBuilder(column: $table.isChoose, builder: (column) => column);

  GeneratedColumn<bool> get isWrong =>
      $composableBuilder(column: $table.isWrong, builder: (column) => column);
}

class $$DbReplyTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DbReplyTable,
    DbReplyData,
    $$DbReplyTableFilterComposer,
    $$DbReplyTableOrderingComposer,
    $$DbReplyTableAnnotationComposer,
    $$DbReplyTableCreateCompanionBuilder,
    $$DbReplyTableUpdateCompanionBuilder,
    (DbReplyData, BaseReferences<_$AppDatabase, $DbReplyTable, DbReplyData>),
    DbReplyData,
    PrefetchHooks Function()> {
  $$DbReplyTableTableManager(_$AppDatabase db, $DbReplyTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbReplyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbReplyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbReplyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> postAutoId = const Value.absent(),
            Value<int> replyId = const Value.absent(),
            Value<String> replyContent = const Value.absent(),
            Value<String> replyUsers = const Value.absent(),
            Value<String> replyText = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> platform = const Value.absent(),
            Value<String> avatar = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> floor = const Value.absent(),
            Value<int> thankCount = const Value.absent(),
            Value<int> replyCount = const Value.absent(),
            Value<int> replyFloor = const Value.absent(),
            Value<bool> isThanked = const Value.absent(),
            Value<bool> isOp = const Value.absent(),
            Value<bool> isDup = const Value.absent(),
            Value<bool> isMod = const Value.absent(),
            Value<bool> isUse = const Value.absent(),
            Value<bool> isChoose = const Value.absent(),
            Value<bool> isWrong = const Value.absent(),
          }) =>
              DbReplyCompanion(
            id: id,
            postAutoId: postAutoId,
            replyId: replyId,
            replyContent: replyContent,
            replyUsers: replyUsers,
            replyText: replyText,
            date: date,
            platform: platform,
            avatar: avatar,
            username: username,
            level: level,
            floor: floor,
            thankCount: thankCount,
            replyCount: replyCount,
            replyFloor: replyFloor,
            isThanked: isThanked,
            isOp: isOp,
            isDup: isDup,
            isMod: isMod,
            isUse: isUse,
            isChoose: isChoose,
            isWrong: isWrong,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int postAutoId,
            Value<int> replyId = const Value.absent(),
            required String replyContent,
            required String replyUsers,
            required String replyText,
            required String date,
            required String platform,
            required String avatar,
            required String username,
            Value<int> level = const Value.absent(),
            Value<int> floor = const Value.absent(),
            Value<int> thankCount = const Value.absent(),
            Value<int> replyCount = const Value.absent(),
            Value<int> replyFloor = const Value.absent(),
            Value<bool> isThanked = const Value.absent(),
            Value<bool> isOp = const Value.absent(),
            Value<bool> isDup = const Value.absent(),
            Value<bool> isMod = const Value.absent(),
            Value<bool> isUse = const Value.absent(),
            Value<bool> isChoose = const Value.absent(),
            Value<bool> isWrong = const Value.absent(),
          }) =>
              DbReplyCompanion.insert(
            id: id,
            postAutoId: postAutoId,
            replyId: replyId,
            replyContent: replyContent,
            replyUsers: replyUsers,
            replyText: replyText,
            date: date,
            platform: platform,
            avatar: avatar,
            username: username,
            level: level,
            floor: floor,
            thankCount: thankCount,
            replyCount: replyCount,
            replyFloor: replyFloor,
            isThanked: isThanked,
            isOp: isOp,
            isDup: isDup,
            isMod: isMod,
            isUse: isUse,
            isChoose: isChoose,
            isWrong: isWrong,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DbReplyTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DbReplyTable,
    DbReplyData,
    $$DbReplyTableFilterComposer,
    $$DbReplyTableOrderingComposer,
    $$DbReplyTableAnnotationComposer,
    $$DbReplyTableCreateCompanionBuilder,
    $$DbReplyTableUpdateCompanionBuilder,
    (DbReplyData, BaseReferences<_$AppDatabase, $DbReplyTable, DbReplyData>),
    DbReplyData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DbPostTableTableManager get dbPost =>
      $$DbPostTableTableManager(_db, _db.dbPost);
  $$DbReplyTableTableManager get dbReply =>
      $$DbReplyTableTableManager(_db, _db.dbReply);
}

mixin _$PostDaoMixin on DatabaseAccessor<AppDatabase> {}
