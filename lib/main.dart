import 'package:flutter/material.dart';
import 'dart:io';
import 'package:admost_flutter_plugin/admost.dart';
import 'package:admost_flutter_plugin/admost_interstitial.dart';
import 'package:admost_flutter_plugin/admost_rewarded.dart';
import 'package:admost_flutter_plugin/admost_ad_events.dart';
import 'package:admost_flutter_plugin/admost_banner.dart';
import 'package:admost_flutter_plugin/admost_banner_size.dart';
import 'package:admost_flutter_plugin/admost_native_ad.dart';
import 'package:admost_flutter_plugin/admost_ios_attrackingmanager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Admost.initialize(
      appId: Platform.isIOS
          ? "15066ddc-9c18-492c-8185-bea7e4c7f88c"
          : "6cc8e89a-b52a-4e9a-bb8c-579f7ec538fe",
      userConsent: "1",
      subjectToGDPR: "1",
      subjectToCCPA: "0");

      if (Platform.isIOS) {
        AdmostATTrackingManager.requestTrackingAuthorization().then((status) {
          print("TrackingAuthorizationStatus: ${status}");
        });
      }
  //Admost.setUserId("myUniqueUserId");
  //AdmostATTrackingManager.getTrackingAuthorizationStatus().then((value) => print("TrackingAuthorizationStatus: ${value}"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Admost Flutter Sample';
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admost',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String interstitialText = 'Load Interstitial';

  AdmostInterstitial? interstitialAd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Center(
        widthFactor: 2,
        heightFactor: 2,
        child: Column(children: <Widget>[
          Card(
            child: InkWell(
              onTap: () {
                Admost.startTestSuite(Platform.isIOS
                    ? "15066ddc-9c18-492c-8185-bea7e4c7f88c"
                    : "6cc8e89a-b52a-4e9a-bb8c-579f7ec538fe");
              },
              child: Center(
                widthFactor: 2,
                heightFactor: 2,
                child: Text("Start Tester Info"),
              ),
            ),
          ),
          Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () async {
                if (interstitialAd == null) {
                  interstitialAd = AdmostInterstitial(
                    zoneId: Platform.isIOS
                        ? '39f74377-5682-436a-9338-9d1c4df410bd'
                        : 'f99e409b-f9ab-4a2e-aa9a-4d143e6809ae',
                    listener: (AdmostAdEvent event, Map<String, dynamic> args) {
                      if (event == AdmostAdEvent.loaded) {
                        print("<ADMOST> Interstitial loaded");
                        print(
                            "<ADMOST> Interstitial network: ${args['network']}");
                        print("<ADMOST> Interstitial ecpm: ${args['ecpm']}");
                        interstitialText = 'Show Interstitial';
                        setState(() {
                          interstitialText;
                        });
                      }
                      if (event == AdmostAdEvent.dismissed) {
                        print("<ADMOST> Interstitial dismissed");
                        interstitialText = 'Load Interstitial';
                        setState(() {
                          interstitialText;
                        });
                      }
                      if (event == AdmostAdEvent.opened) {
                        print("<ADMOST> Interstitial Opened");
                      }
                      if (event == AdmostAdEvent.failedToLoad) {
                        print("<ADMOST> Interstitial failedToLoad");
                        print(
                            "<ADMOST> Interstitial Error code: ${args['errorCode']}");
                        print(
                            "<ADMOST> Interstitial Error description: ${args['errorMessage']}");
                      }
                      if (event == AdmostAdEvent.failedToShow) {
                        print("<ADMOST> Interstitial failedToShow");
                        print(
                            "<ADMOST> Interstitial Error code: ${args['errorCode']}");
                        print(
                            "<ADMOST> Interstitial Error description: ${args['errorMessage']}");
                      }
                    },
                  );
                }

                if (await interstitialAd?.isLoaded ?? false) {
                  interstitialAd?.show();
                  // If you want to add tag, you should remove the line above and use the code below (optional)
                  // interstitialAd.show("YOUR TAG");
                } else {
                  interstitialAd?.load();
                }
              },
              child: Center(
                widthFactor: 2,
                heightFactor: 2,
                child: Text(interstitialText),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
