import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:picance/core/constants/app_contants.dart';
import 'package:picance/core/utils/file_util.dart';

class ImgupscalerApi {
  static CancelToken _cancelToken = CancelToken();

  ImgupscalerApi._();

  static final Dio _dio =
      Dio()
        ..options.baseUrl = 'https://get1.imglarger.com/api/UpscalerNew'
        ..options.headers = {
          'Origin': 'https://imgupscaler.com',
          'Host': 'get1.imglarger.com',
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36',
        };

  // First API: Upload image
  static Future<String> _uploadImage(
    String imagePath,
    String scaleRadio,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'myfile': await MultipartFile.fromFile(
          imagePath,
          filename: basename(imagePath),
          contentType: MediaType.parse("image/jpeg"),
        ),
        'scaleRadio': scaleRadio,
      });

      Response response = await _dio.post(
        '/UploadNew',
        data: formData,
        cancelToken: _cancelToken,
      );

      if (response.statusCode == 200 && response.data['code'] == 200) {
        return response.data['data']['code'];
      } else {
        // throw Exception('Failed to upload image: ${response.data['msg']}');
        return "";
      }
    } catch (e) {
      // throw Exception('Failed to upload image: $e');
      return "";
    }
  }

  // Second API: Check status
  static Future<Map<String, dynamic>> _checkStatus(
    String code,
    String scaleRadio,
  ) async {
    try {
      Response response = await _dio.post(
        '/CheckStatusNew',
        cancelToken: _cancelToken,
        data: {'code': code, 'scaleRadio': int.parse(scaleRadio)},
      );

      if (response.statusCode == 200 && response.data['code'] == 200) {
        return response.data;
      } else {
        // throw Exception('Failed to check status: $response');
        return {};
      }
    } catch (e) {
      // throw Exception('Failed to check status: $e');
      return {};
    }
  }

  // Polling function to check status until completion
  static Future<Map<String, dynamic>> _pollForResult(
    String code,
    String scaleRadio,
  ) async {
    while (true) {
      try {
        final result = await _checkStatus(code, scaleRadio);

        if (result['data']['status'] == 'success') {
          return result;
        }

        // Wait for 5 seconds before next check
        await Future.delayed(const Duration(seconds: 5));
      } catch (e) {
        // throw Exception('Error while polling: $e');
        return {};
      }
    }
  }

  // Combined function to handle the whole process
  static Future<List<String>> upscaleImage(
    List<String> imagePaths,
    String scaleRadio,
    String timeStamp,
    bool latestSaved,
  ) async {
    String appFolder = AppContants.appFolder;
    try {
      List<String> imagePathSaved = [];

      for (final imagePath in imagePaths) {
        // Step 1: Upload image
        final code = await _uploadImage(imagePath, scaleRadio);

        // Step 2: Poll for result
        final result = await _pollForResult(code, scaleRadio);
        String downloadUrls = result["data"]["downloadUrls"][0];
        String imageName = basename(result["data"]["originalfilename"]);

        File? file;
        if (latestSaved == false) {
          file = await FileUtil.saveImageToTempDirFromImageUrl(
            downloadUrls,
            imageName,
          );
        } else {
          file = await FileUtil.saveImageToFolderFromImageUrl(
            downloadUrls,
            imageName,
            "$appFolder/$timeStamp",
          );
        }
        imagePathSaved.add(file.path);
      }
      return imagePathSaved;
    } catch (e) {
      return imagePaths;
    }
  }

  static void cancelRequest() {
    _cancelToken.cancel("User canceled request");
    _cancelToken = CancelToken();
  }
}
