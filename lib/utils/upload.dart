import 'dart:math';

import 'package:dio/dio.dart';
import 'package:v2ex/http/request.dart';
import 'package:v2ex/model/model.dart';
import 'package:v2ex/utils/const_val.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class Upload {
  static const clientId = [
    "0db8b3c3e10d89b",
    "6b91ec71f6af441",
    '3107b9ef8b316f3',
    '442b04f26eefc8a',
    '59cfebe717c09e4',
    '60605aad4a62882',
    '6c65ab1d3f5452a',
    '83e123737849aa9',
    '9311f6be1c10160',
    'c4a4a563f698595',
    '81be04b9e4a08ce',
  ];
  static const String uploadBaseUrl = 'https://api.imgur.com/3/upload';

  static Future<Result> uploadImage(AssetEntity file) async {
    FormData formData = FormData.fromMap(
      {
        'image': await Upload().multipartFileFromAssetEntity(file),
        // 'type': 'file'
      },
    );
    Options options = Options();
    options.headers = {
      'Authorization': "Client-ID ${clientId[Random().nextInt(clientId.length)]}",
      'user-agent': Const.agent.pc,
    };
    options.method = 'POST';
    options.contentType = 'multipart/form-data';
    var result = await Http().upload(uploadBaseUrl, data: formData, options: options);
    if (result.statusCode == 200) {
      return Result(success: result.data['success'], data: result.data['data']);
    }
    return Result(success: false);
  }

  Future<MultipartFile> multipartFileFromAssetEntity(AssetEntity entity) async {
    MultipartFile mf;
    // Using the file path.
    final file = await entity.file;
    if (file == null) {
      throw StateError('Unable to obtain file of the entity ${entity.id}.');
    }
    mf = await MultipartFile.fromFile(file.path, filename: 'image');
    // Using the bytes.
    final bytes = await entity.originBytes;
    if (bytes == null) {
      throw StateError('Unable to obtain bytes of the entity ${entity.id}.');
    }
    mf = MultipartFile.fromBytes(bytes);
    return mf;
  }
}
