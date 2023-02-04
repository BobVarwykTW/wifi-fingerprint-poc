import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';

class Wifi extends StatefulWidget {
  const Wifi({super.key});

  @override
  State<Wifi> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Wifi> {
  List<WiFiAccessPoint> _networks = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? _subscription;

  // Whether or not the app is scanning for Wifi Networks.
  bool get isScanning => _subscription != null;

  // The Wifi Name we need to recognize.
  final String _wifiTargetName = "AndroidWifi";

  @override
  void initState() {
    super.initState();
    _scanForWifiNetWork();
  }

  void _scanForWifiNetWork() {
    // We check if we can even run the Wifi Scan Package.
    WiFiScan.instance.canStartScan().then((value) async {
      // If Yes, we fire `.startScan()`
      if (value == CanStartScan.yes) {
        await WiFiScan.instance.startScan();

        // Listen to the results.
        _subscription =
            WiFiScan.instance.onScannedResultsAvailable.listen((networks) {
          if (mounted) setState(() => _networks = networks);
        });
      }
    }).onError((error, stackTrace) {
      debugPrint('${error.toString()}: $stackTrace');
    });
  }

  // Whether or not the target WiFi is in range of the device.
  bool targetWifiInRange() {
    for (var network in _networks) {
      if (network.ssid == _wifiTargetName) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    targetWifiInRange();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: SafeArea(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Scanning for Network: $_wifiTargetName'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 15),
              Text(
                '',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 50),
              Text(
                'In range:'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 15),
              Text(
                '${targetWifiInRange()}'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 50),
              Text(
                'Detected WiFi Networks'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 25),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _networks.length,
                itemBuilder: (context, index) {
                  return Text(
                    _networks[index].ssid.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
