// lib/main.dart
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:newass/widgets/widgets_playerardview.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  VisibilityDetectorController.instance.updateInterval = const Duration(
    milliseconds: 200,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BetterPlayer — 10 Live HLS Streams',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1722),
        cardColor: const Color(0xFF111827),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const MultiLivePage(),
    );
  }
}

class MultiLivePage extends StatefulWidget {
  const MultiLivePage({super.key});
  @override
  State<MultiLivePage> createState() => _MultiLivePageState();
}

class _MultiLivePageState extends State<MultiLivePage> {
  final List<String> urls = const [
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
    'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8',
    'https://cph-p2p-msl.akamaized.net/hls/live/2000341/test/master.m3u8',
    'https://mojenmoje-live.mncnow.id/live/eds/NETtv-HD/sa_dash_vmx/NETtv-HD.m3u8',
    'https://d2hxw1celoutbe.cloudfront.net/playlist.m3u8',
    'https://mnmedias.api.telequebec.tv/m3u8/29880.m3u8',
    'https://streaming.3sat.de/hls/live/2013675/de/master.m3u8',
    'https://live-hls-web-aje.getaj.net/AJE/01.m3u8',
    'https://rt-glb.rttv.com/live/rtnews/playlist.m3u8',
    'https://iptv-org.github.io/streams/tv.m3u8',
  ];

  final List<BetterPlayerController> controllers = [];
  final Map<int, bool> shouldPlay = {};

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < urls.length; i++) {
      controllers.add(_createController(urls[i]));
      shouldPlay[i] = true;
    }
  }

  BetterPlayerController _createController(String url) {
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      liveStream: true,
    );

    final config = BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      autoPlay: true,
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        showControls: false, // custom overlay used
      ),
      handleLifecycle: true,
      allowedScreenSleep: false,
    );

    final controller = BetterPlayerController(config);
    controller.setupDataSource(dataSource).then((_) {
      controller.setVolume(
        0.0,
      ); // mute by default to avoid noise when many streams load
      controller.play();
    });
    return controller;
  }

  @override
  void dispose() {
    for (final c in controllers) {
      try {
        c.dispose();
      } catch (_) {}
    }
    controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('10 Live HLS Streams')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: controllers.length,
        itemBuilder: (context, index) {
          return PlayerCard(
            index: index,
            controller: controllers[index],
            title: 'Live Stream ${index + 1}',
            onVisibilityChanged: (visible) async {
              for (int i = 0; i < controllers.length; i++) {
                if (i == index && visible) {
                  // stop all others first
                  await controllers[i].pause();
                  await controllers[i].play();
                  shouldPlay[i] = true;
                } else {
                  await controllers[i].pause();
                  shouldPlay[i] = false;
                }
              }
              if (mounted) setState(() {});
            },
          );
        },
      ),
    );
  }
}
