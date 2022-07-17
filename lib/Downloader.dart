import 'dart:developer';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';

class Download {
  Future<void> downloadVideo(String url, String title) async {
    final download = FlutterYoutubeDownloader.downloadVideo(url, title, 18);
    log(download.toString());
  }
}
