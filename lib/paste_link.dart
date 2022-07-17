import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qtube/Bloc/YouBloc.dart';
import 'package:qtube/Bloc/YouState.dart';
import 'package:qtube/Downloader.dart';

class PasteLink extends StatefulWidget {
  const PasteLink({Key? key}) : super(key: key);

  @override
  State<PasteLink> createState() => _PasteLinkState();
}

class _PasteLinkState extends State<PasteLink> {
  TextEditingController linkController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 500,
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: linkController,
              decoration: const InputDecoration(
                labelText: 'Paste link here..',
              ),
              keyboardType: TextInputType.url,
            ),
          ),
          BlocConsumer<YoutubeBloc, YoutubeState>(
            listener: (context, state) {
              if (state is VideoDownloadState) {
                if (state.isLoading) {
                  EasyLoading.show(status: 'Loading');
                }
              }
            },
            builder: (context, state) {
              return Container(
                width: 300,
                margin: const EdgeInsets.all(30),
                decoration: const BoxDecoration(color: Colors.red),
                child: TextButton(
                  onPressed: () {
                    if (linkController.text.isEmpty) {
                      const snackBar = SnackBar(
                        content: Text('No link detected'),
                        duration: Duration(seconds: 2),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      BlocProvider.of<YoutubeBloc>(context).DownloadVideo(
                          linkController.text.trim(), 'Video Downloading');
                    }
                  },
                  child: const Text(
                    'Download',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: isAdLoaded
          ? SizedBox(
              width: bannerAd.size.width.toDouble(),
              height: bannerAd.size.height.toDouble(),
              child: AdWidget(ad: bannerAd),
            )
          : const SizedBox(),
    );
  }
}
