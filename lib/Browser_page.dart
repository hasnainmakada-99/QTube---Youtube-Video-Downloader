import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qtube/Downloader.dart';
import 'package:qtube/Main_Page.dart';
import 'package:qtube/main.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Bloc/YouBloc.dart';
import 'Bloc/YouState.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({Key? key}) : super(key: key);

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  WebViewController? controller;
  final link = 'https://www.youtube.com';
  bool showDownloadButton = false;
  late BannerAd bannerAd;
  bool isAdLoaded = false;

  @override
  void initState() {
    initBannerAd();
    super.initState();
  }

  initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-8351931034895476/8636749676',
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(
            () {
              isAdLoaded = true;
            },
          );
        },
        onAdFailedToLoad: (ad, err) {},
      ),
    );

    bannerAd.load();
  }

  void checkUrl() async {
    if (await controller!.currentUrl() == 'https://m.youtube.com/') {
      setState(
        () {
          showDownloadButton = false;
        },
      );
    } else {
      setState(
        () {
          showDownloadButton = true;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    checkUrl();
    return WillPopScope(
      onWillPop: () async {
        if (await controller!.canGoBack()) {
          controller!.goBack();
        }
        return false;
      },
      child: Scaffold(
        body: WebView(
          initialUrl: link,
          javascriptMode: JavascriptMode.unrestricted,
          onWebResourceError: (error) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Something went wrong'),
                  content: const Text('Missing internet connection'),
                  scrollable: true,
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Homepage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text('Okay'),
                    ),
                  ],
                );
              },
            );
          },
          onWebViewCreated: (_controller) {
            setState(() {
              controller = _controller;
            });
          },
        ),
        floatingActionButton: showDownloadButton == false
            ? Container()
            : BlocBuilder<YoutubeBloc, YoutubeState>(
                builder: (context, state) {
                  return FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: () async {
                      final url = await controller!.currentUrl();
                      final title = await controller!.getTitle();
                      // ignore: use_build_context_synchronously
                      BlocProvider.of<YoutubeBloc>(context)
                          .DownloadVideo(url!, "$title");
                      //Download().downloadVideo(url!, "$title");
                    },
                    child: const Icon(Icons.download),
                  );
                },
              ),
        bottomNavigationBar: isAdLoaded
            ? SizedBox(
                width: bannerAd.size.width.toDouble(),
                height: bannerAd.size.height.toDouble(),
                child: AdWidget(ad: bannerAd),
              )
            : const SizedBox(),
      ),
    );
  }
}
