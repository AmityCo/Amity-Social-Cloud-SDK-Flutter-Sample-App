import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;

abstract class DownloadService {
  Future<String> download({required String url});
}

class WebDownloadService implements DownloadService {
  @override
  Future<String> download({required String url}) async {
    html.window.open(url, "_blank");
    return '';
  }
}

class MobileDownloadService implements DownloadService {
  @override
  Future<String> download({required String url}) async {
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return '';

    Dio dio = Dio();
    var dir = await (Platform.isAndroid ? getExternalStorageDirectory() : getLibraryDirectory());

    // You should put the name you want for the file here.
    // Take in account the extension.
    String fileName = 'myFile';
    await dio.download(url, "${dir!.path}/$fileName");

    return "${dir.path}/$fileName";
  }

  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }
}
