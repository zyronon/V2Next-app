// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TodoItemsTable extends TodoItems
    with TableInfo<$TodoItemsTable, TodoItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoItemsTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> postId = GeneratedColumn<String>(
      'post_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 6, maxTextLength: 8),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 6, maxTextLength: 32),
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
        isMove
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_items';
  @override
  VerificationContext validateIntegrity(Insertable<TodoItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('post_id')) {
      context.handle(_postIdMeta,
          postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta));
    } else if (isInserting) {
      context.missing(_postIdMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      postId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}post_id'])!,
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
    );
  }

  @override
  $TodoItemsTable createAlias(String alias) {
    return $TodoItemsTable(attachedDatabase, alias);
  }
}

class TodoItem extends DataClass implements Insertable<TodoItem> {
  final int id;
  final String postId;
  final String title;
  final String contentRendered;
  final String contentText;
  final String createDate;
  final String createDateAgo;
  final String lastReplyDate;
  final String lastReplyDateAgo;
  final String lastReplyUsername;
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
  const TodoItem(
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
      required this.isMove});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['post_id'] = Variable<String>(postId);
    map['title'] = Variable<String>(title);
    map['content_rendered'] = Variable<String>(contentRendered);
    map['content_text'] = Variable<String>(contentText);
    map['create_date'] = Variable<String>(createDate);
    map['create_date_ago'] = Variable<String>(createDateAgo);
    map['last_reply_date'] = Variable<String>(lastReplyDate);
    map['last_reply_date_ago'] = Variable<String>(lastReplyDateAgo);
    map['last_reply_username'] = Variable<String>(lastReplyUsername);
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
    return map;
  }

  TodoItemsCompanion toCompanion(bool nullToAbsent) {
    return TodoItemsCompanion(
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
    );
  }

  factory TodoItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoItem(
      id: serializer.fromJson<int>(json['id']),
      postId: serializer.fromJson<String>(json['postId']),
      title: serializer.fromJson<String>(json['title']),
      contentRendered: serializer.fromJson<String>(json['contentRendered']),
      contentText: serializer.fromJson<String>(json['contentText']),
      createDate: serializer.fromJson<String>(json['createDate']),
      createDateAgo: serializer.fromJson<String>(json['createDateAgo']),
      lastReplyDate: serializer.fromJson<String>(json['lastReplyDate']),
      lastReplyDateAgo: serializer.fromJson<String>(json['lastReplyDateAgo']),
      lastReplyUsername: serializer.fromJson<String>(json['lastReplyUsername']),
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
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'postId': serializer.toJson<String>(postId),
      'title': serializer.toJson<String>(title),
      'contentRendered': serializer.toJson<String>(contentRendered),
      'contentText': serializer.toJson<String>(contentText),
      'createDate': serializer.toJson<String>(createDate),
      'createDateAgo': serializer.toJson<String>(createDateAgo),
      'lastReplyDate': serializer.toJson<String>(lastReplyDate),
      'lastReplyDateAgo': serializer.toJson<String>(lastReplyDateAgo),
      'lastReplyUsername': serializer.toJson<String>(lastReplyUsername),
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
    };
  }

  TodoItem copyWith(
          {int? id,
          String? postId,
          String? title,
          String? contentRendered,
          String? contentText,
          String? createDate,
          String? createDateAgo,
          String? lastReplyDate,
          String? lastReplyDateAgo,
          String? lastReplyUsername,
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
          bool? isMove}) =>
      TodoItem(
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
      );
  TodoItem copyWithCompanion(TodoItemsCompanion data) {
    return TodoItem(
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
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoItem(')
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
          ..write('isMove: $isMove')
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
        isMove
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoItem &&
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
          other.isMove == this.isMove);
}

class TodoItemsCompanion extends UpdateCompanion<TodoItem> {
  final Value<int> id;
  final Value<String> postId;
  final Value<String> title;
  final Value<String> contentRendered;
  final Value<String> contentText;
  final Value<String> createDate;
  final Value<String> createDateAgo;
  final Value<String> lastReplyDate;
  final Value<String> lastReplyDateAgo;
  final Value<String> lastReplyUsername;
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
  const TodoItemsCompanion({
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
  });
  TodoItemsCompanion.insert({
    this.id = const Value.absent(),
    required String postId,
    required String title,
    required String contentRendered,
    required String contentText,
    required String createDate,
    required String createDateAgo,
    required String lastReplyDate,
    required String lastReplyDateAgo,
    required String lastReplyUsername,
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
  })  : postId = Value(postId),
        title = Value(title),
        contentRendered = Value(contentRendered),
        contentText = Value(contentText),
        createDate = Value(createDate),
        createDateAgo = Value(createDateAgo),
        lastReplyDate = Value(lastReplyDate),
        lastReplyDateAgo = Value(lastReplyDateAgo),
        lastReplyUsername = Value(lastReplyUsername);
  static Insertable<TodoItem> custom({
    Expression<int>? id,
    Expression<String>? postId,
    Expression<String>? title,
    Expression<String>? contentRendered,
    Expression<String>? contentText,
    Expression<String>? createDate,
    Expression<String>? createDateAgo,
    Expression<String>? lastReplyDate,
    Expression<String>? lastReplyDateAgo,
    Expression<String>? lastReplyUsername,
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
    });
  }

  TodoItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? postId,
      Value<String>? title,
      Value<String>? contentRendered,
      Value<String>? contentText,
      Value<String>? createDate,
      Value<String>? createDateAgo,
      Value<String>? lastReplyDate,
      Value<String>? lastReplyDateAgo,
      Value<String>? lastReplyUsername,
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
      Value<bool>? isMove}) {
    return TodoItemsCompanion(
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
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (postId.present) {
      map['post_id'] = Variable<String>(postId.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoItemsCompanion(')
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
          ..write('isMove: $isMove')
          ..write(')'))
        .toString();
  }
}

class $TodoCategoryTable extends TodoCategory
    with TableInfo<$TodoCategoryTable, TodoCategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoCategoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_category';
  @override
  VerificationContext validateIntegrity(Insertable<TodoCategoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoCategoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoCategoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
    );
  }

  @override
  $TodoCategoryTable createAlias(String alias) {
    return $TodoCategoryTable(attachedDatabase, alias);
  }
}

class TodoCategoryData extends DataClass
    implements Insertable<TodoCategoryData> {
  final int id;
  final String description;
  const TodoCategoryData({required this.id, required this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    return map;
  }

  TodoCategoryCompanion toCompanion(bool nullToAbsent) {
    return TodoCategoryCompanion(
      id: Value(id),
      description: Value(description),
    );
  }

  factory TodoCategoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoCategoryData(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
    };
  }

  TodoCategoryData copyWith({int? id, String? description}) => TodoCategoryData(
        id: id ?? this.id,
        description: description ?? this.description,
      );
  TodoCategoryData copyWithCompanion(TodoCategoryCompanion data) {
    return TodoCategoryData(
      id: data.id.present ? data.id.value : this.id,
      description:
          data.description.present ? data.description.value : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoCategoryData(')
          ..write('id: $id, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoCategoryData &&
          other.id == this.id &&
          other.description == this.description);
}

class TodoCategoryCompanion extends UpdateCompanion<TodoCategoryData> {
  final Value<int> id;
  final Value<String> description;
  const TodoCategoryCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
  });
  TodoCategoryCompanion.insert({
    this.id = const Value.absent(),
    required String description,
  }) : description = Value(description);
  static Insertable<TodoCategoryData> custom({
    Expression<int>? id,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
    });
  }

  TodoCategoryCompanion copyWith({Value<int>? id, Value<String>? description}) {
    return TodoCategoryCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoCategoryCompanion(')
          ..write('id: $id, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TodoItemsTable todoItems = $TodoItemsTable(this);
  late final $TodoCategoryTable todoCategory = $TodoCategoryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [todoItems, todoCategory];
}

typedef $$TodoItemsTableCreateCompanionBuilder = TodoItemsCompanion Function({
  Value<int> id,
  required String postId,
  required String title,
  required String contentRendered,
  required String contentText,
  required String createDate,
  required String createDateAgo,
  required String lastReplyDate,
  required String lastReplyDateAgo,
  required String lastReplyUsername,
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
});
typedef $$TodoItemsTableUpdateCompanionBuilder = TodoItemsCompanion Function({
  Value<int> id,
  Value<String> postId,
  Value<String> title,
  Value<String> contentRendered,
  Value<String> contentText,
  Value<String> createDate,
  Value<String> createDateAgo,
  Value<String> lastReplyDate,
  Value<String> lastReplyDateAgo,
  Value<String> lastReplyUsername,
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
});

class $$TodoItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postId => $composableBuilder(
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
}

class $$TodoItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postId => $composableBuilder(
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
}

class $$TodoItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get postId =>
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
}

class $$TodoItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TodoItemsTable,
    TodoItem,
    $$TodoItemsTableFilterComposer,
    $$TodoItemsTableOrderingComposer,
    $$TodoItemsTableAnnotationComposer,
    $$TodoItemsTableCreateCompanionBuilder,
    $$TodoItemsTableUpdateCompanionBuilder,
    (TodoItem, BaseReferences<_$AppDatabase, $TodoItemsTable, TodoItem>),
    TodoItem,
    PrefetchHooks Function()> {
  $$TodoItemsTableTableManager(_$AppDatabase db, $TodoItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> postId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> contentRendered = const Value.absent(),
            Value<String> contentText = const Value.absent(),
            Value<String> createDate = const Value.absent(),
            Value<String> createDateAgo = const Value.absent(),
            Value<String> lastReplyDate = const Value.absent(),
            Value<String> lastReplyDateAgo = const Value.absent(),
            Value<String> lastReplyUsername = const Value.absent(),
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
          }) =>
              TodoItemsCompanion(
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
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String postId,
            required String title,
            required String contentRendered,
            required String contentText,
            required String createDate,
            required String createDateAgo,
            required String lastReplyDate,
            required String lastReplyDateAgo,
            required String lastReplyUsername,
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
          }) =>
              TodoItemsCompanion.insert(
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
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TodoItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TodoItemsTable,
    TodoItem,
    $$TodoItemsTableFilterComposer,
    $$TodoItemsTableOrderingComposer,
    $$TodoItemsTableAnnotationComposer,
    $$TodoItemsTableCreateCompanionBuilder,
    $$TodoItemsTableUpdateCompanionBuilder,
    (TodoItem, BaseReferences<_$AppDatabase, $TodoItemsTable, TodoItem>),
    TodoItem,
    PrefetchHooks Function()>;
typedef $$TodoCategoryTableCreateCompanionBuilder = TodoCategoryCompanion
    Function({
  Value<int> id,
  required String description,
});
typedef $$TodoCategoryTableUpdateCompanionBuilder = TodoCategoryCompanion
    Function({
  Value<int> id,
  Value<String> description,
});

class $$TodoCategoryTableFilterComposer
    extends Composer<_$AppDatabase, $TodoCategoryTable> {
  $$TodoCategoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));
}

class $$TodoCategoryTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoCategoryTable> {
  $$TodoCategoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));
}

class $$TodoCategoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoCategoryTable> {
  $$TodoCategoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);
}

class $$TodoCategoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TodoCategoryTable,
    TodoCategoryData,
    $$TodoCategoryTableFilterComposer,
    $$TodoCategoryTableOrderingComposer,
    $$TodoCategoryTableAnnotationComposer,
    $$TodoCategoryTableCreateCompanionBuilder,
    $$TodoCategoryTableUpdateCompanionBuilder,
    (
      TodoCategoryData,
      BaseReferences<_$AppDatabase, $TodoCategoryTable, TodoCategoryData>
    ),
    TodoCategoryData,
    PrefetchHooks Function()> {
  $$TodoCategoryTableTableManager(_$AppDatabase db, $TodoCategoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoCategoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoCategoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoCategoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> description = const Value.absent(),
          }) =>
              TodoCategoryCompanion(
            id: id,
            description: description,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String description,
          }) =>
              TodoCategoryCompanion.insert(
            id: id,
            description: description,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TodoCategoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TodoCategoryTable,
    TodoCategoryData,
    $$TodoCategoryTableFilterComposer,
    $$TodoCategoryTableOrderingComposer,
    $$TodoCategoryTableAnnotationComposer,
    $$TodoCategoryTableCreateCompanionBuilder,
    $$TodoCategoryTableUpdateCompanionBuilder,
    (
      TodoCategoryData,
      BaseReferences<_$AppDatabase, $TodoCategoryTable, TodoCategoryData>
    ),
    TodoCategoryData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TodoItemsTableTableManager get todoItems =>
      $$TodoItemsTableTableManager(_db, _db.todoItems);
  $$TodoCategoryTableTableManager get todoCategory =>
      $$TodoCategoryTableTableManager(_db, _db.todoCategory);
}
