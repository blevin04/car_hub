 import 'package:car_hub/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

InterstitialAd? interstitialAd;
/// Loads an interstitial ad.
  Future<InterstitialAd> loadAd(BuildContext context)async {
    await InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> page));
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {}
            );
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
             interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
        print("////////////////////");
        return interstitialAd!;
  }

