import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:picance/core/constants/app_contants.dart';
import 'package:picance/core/utils/file_util.dart';

class IloveimgApi {
  IloveimgApi._();

  static CancelToken _cancelToken = CancelToken();
  static final List<String> _listApis = [
    "api1g",
    "api2g",
    "api3g",
    "api7g",
    "api8g",
    "api9g",
    "api10g",
    "api11g",
    "api12g",
    "api13g",
    "api14g",
    "api15g",
    "api16g",
    "api17g",
    "api18g",
    "api19g",
    "api20g",
    "api1g",
    "api1g",
    "api1g",
    "api2g",
    "api2g",
    "api2g",
    "api3g",
    "api3g",
    "api3g",
    "api11g",
    "api11g",
    "api11g",
  ];
  static final String _userAgent =
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36";
  static final String _token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIiLCJhdWQiOiIiLCJpYXQiOjE1MjMzNjQ4MjQsIm5iZiI6MTUyMzM2NDgyNCwianRpIjoicHJvamVjdF9wdWJsaWNfYzkwNWRkMWMwMWU5ZmQ3NzY5ODNjYTQwZDBhOWQyZjNfT1Vzd2EwODA0MGI4ZDJjN2NhM2NjZGE2MGQ2MTBhMmRkY2U3NyJ9.qvHSXgCJgqpC4gd6-paUlDLFmg0o2DsOvb1EUYPYx_E";
  static String? _taskId = '';
  static String? _server = '';

  // lấy ngẫu nhiên 1 api
  static String _serverRadom() {
    final random = Random();
    String radomApi = _listApis[random.nextInt(_listApis.length)];
    return radomApi;
  }

  static Future<void> _getTaskId() async {
    const String url = "https://www.iloveimg.com/upscale-image";
    final dio = Dio();

    try {
      // Cấu hình request với timeout và headers
      final response = await dio.get(
        url,
        cancelToken: _cancelToken,
        options: Options(
          headers: {'User-Agent': _userAgent},
          receiveTimeout: const Duration(minutes: 5), // Timeout nhận dữ liệu
          sendTimeout: const Duration(minutes: 5), // Timeout gửi request
        ),
      );

      // Đảm bảo rằng response là thành công
      if (response.statusCode == 200) {
        // Tìm kiếm taskId trong nội dung response
        final RegExp regex = RegExp(r"ilovepdfConfig\.taskId\s*=\s*'([^']*)'");
        final match = regex.firstMatch(response.data.toString());

        _taskId = match?.group(1);
      } else {
        _taskId = null;
      }
    } on DioException catch (e) {
      // Xử lý các loại lỗi cụ thể của Dio
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        // print('Request timeout');
      } else {
        // print('Error occurred: ${e.message}');
      }
      _taskId = null;
    } catch (e) {
      // print('Unexpected error: $e');
      _taskId = null;
    }
  }

  static Future<List<String>> _getServerFileNames(
    List<String> imageFilePaths,
  ) async {
    await _getTaskId();
    _server = _serverRadom();
    final Dio dio = Dio();

    final List<String> uploadResponses = [];
    final String uploadUrl = "https://$_server.iloveimg.com/v1/upload";

    try {
      for (int i = 0; i < imageFilePaths.length; i++) {
        final filePath = imageFilePaths[i];

        final fileName = path.basename(filePath);
        final file = await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: MediaType.parse("image/png"),
        );

        final formData = FormData.fromMap({
          'file': file,
          'name': fileName,
          'chunk': '0',
          'chunks': '1',
          'task': _taskId ?? '',
          'preview': '1',
          'pdfinfo': '0',
          'pdfforms': '0',
          'pdfresetforms': '0',
          'v': 'web.0',
        });

        final response = await dio.post(
          uploadUrl,
          data: formData,
          cancelToken: _cancelToken,
          options: Options(
            headers: {
              'Authorization': 'Bearer $_token',
              'User-Agent': _userAgent,
              'Content-Type': 'multipart/form-data',
            },
            sendTimeout: const Duration(minutes: 5),
            receiveTimeout: const Duration(minutes: 5),
          ),
        );

        if (response.statusCode == 200) {
          uploadResponses.add(response.data['server_filename']);
        } else {
          // print("❌ Failed to upload file, Status: ${response}");
        }

        await Future.delayed(const Duration(milliseconds: 600));
      }
    } catch (e) {
      // print("❌ Error uploading files: $e");
    }

    return uploadResponses;
  }

  static Future<List<String>> scaling(
    List<String> imageUploads,
    String scale,
    String timeStamp,
    bool latestSaved,
  ) async {
    List<String> imagePathSaved = [];

    final serverFileNames = await _getServerFileNames(imageUploads);
    final Dio dio = Dio();
    final String scaleUrl = 'https://$_server.iloveimg.com/v1/upscale';

    try {
      final headers = {
        'Authorization': 'Bearer $_token',
        'User-Agent': _userAgent,
      };

      String appFolder = AppContants.appFolder;

      for (int i = 0; i < serverFileNames.length; i++) {
        final formData = FormData.fromMap({
          'task': _taskId ?? '',
          'server_filename': serverFileNames[i],
          'scale': scale,
        });

        final response = await dio.post(
          scaleUrl,
          data: formData,
          cancelToken: _cancelToken,
          options: Options(
            headers: headers,
            responseType: ResponseType.bytes, // Lấy dữ liệu ảnh dưới dạng bytes
            sendTimeout: const Duration(minutes: 5),
            receiveTimeout: const Duration(minutes: 5),
          ),
        );
        await Future.delayed(const Duration(seconds: 1));

        if (response.statusCode != 200) {
          continue;
        }

        final imageBytes = response.data;
        File? file;
        if (latestSaved == false) {
          file = await FileUtil.saveImageToTempDirFromBytes(
            imageBytes,
            serverFileNames[i],
          );
        } else {
          file = await FileUtil.saveImageToFolderFromBytes(
            imageBytes,
            serverFileNames[i],
            "$appFolder/$timeStamp",
          );
        }
        imagePathSaved.add(file.path);
      }
      return imagePathSaved;
    } catch (e) {
      return imageUploads;
    }
  }

  static void cancelRequest() {
    _cancelToken.cancel("User canceled request");
    _cancelToken = CancelToken();
  }
}
