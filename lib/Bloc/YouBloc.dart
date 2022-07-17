import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:qtube/Bloc/YouState.dart';

class YoutubeBloc extends Cubit<YoutubeState> {
  YoutubeBloc() : super(YoutubeState(isLoading: true));

  void DownloadVideo(String url, String title) async {
    final download =
        await FlutterYoutubeDownloader.downloadVideo(url, title, 18);
    log(download.toString());
    emit(VideoDownloadState());
  }
}
