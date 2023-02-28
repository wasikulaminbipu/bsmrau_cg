import 'dart:isolate';
import 'dart:ui';

import 'package:bsmrau_cg/app_constants.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class Downloader {
  ReceivePort _port = ReceivePort();

  bool _isRegistered = false;
  bool _isInitialized = false;

  void Function(dynamic data) onChanged = (data) {
    print(data[3] + 'Progress');
  };

  String _id = '';
  int _progress = 0;
  DownloadTaskStatus _status = DownloadTaskStatus.undefined;

  Future<void> initialize() async {
    if (_isInitialized) return;
    await FlutterDownloader.initialize(
        debug:
            true, // optional: set to false to disable printing logs to console (default: true)
        ignoreSsl:
            true // option: set to false to disable working with http links (default: false)
        );
    _isInitialized = true;
  }

  Future<void> register() async {
    if (_isRegistered) return;

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    // _port.listen((dynamic data) {
    //   _id = data[0];
    //   _status = data[1];
    //   _progress = data[2];
    // });

    _port.listen(onChanged);

    await FlutterDownloader.registerCallback(downloadCallback);
    _isRegistered = true;
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
    print(progress);
  }

  void dispose() {
    if (!_isRegistered) return;
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    _isRegistered = false;
  }

  Future<void> download({required String source, required String path}) async {
    register();
    final taskId = await FlutterDownloader.enqueue(
      url: '${AppConstants.rawDownloadUrl}/$source',
      fileName: source,
      headers: {}, // optional: header send with url (auth token etc)
      savedDir: path,
      showNotification: false,
      openFileFromNotification: false,
    );
  }
}
