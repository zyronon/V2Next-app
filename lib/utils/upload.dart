import 'dart:math';

import 'package:dio/dio.dart';
import 'package:v2ex/utils/ConstVal.dart';
import 'package:v2ex/utils/request.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class Upload {
  static const clientId = ["0db8b3c3e10d89b", "6b91ec71f6af441"];
  static const String uploadBaseUrl = 'https://api.imgur.com/3/image';

  static Future uploadImage(String key, AssetEntity file) async {
    FormData formData = FormData.fromMap(
      {
        'image': await Upload().multipartFileFromAssetEntity(file),
        // 'type': 'file'
      },
    );
    Options options = Options();
    options.headers = {
      'Authorization': "Client-ID ${clientId[Random().nextInt(2)]}",
      'user-agent': Const.agent.pc,
    };
    options.method = 'POST';
    options.contentType = 'multipart/form-data';
    var result = await Http().upload(uploadBaseUrl, data: formData, options: options);
    return result.data['data'];
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
