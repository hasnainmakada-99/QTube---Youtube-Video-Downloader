class YoutubeState {
  bool isLoading;
  YoutubeState({required this.isLoading});
}

class VideoDownloadState extends YoutubeState {
  VideoDownloadState() : super(isLoading: false);
}
