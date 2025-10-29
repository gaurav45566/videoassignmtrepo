// // // // lib/widgets/player_overlay.dart
// // // import 'dart:async';
// // // import 'package:flutter/material.dart';
// // // import 'package:better_player/better_player.dart';

// // // class PlayerOverlay extends StatefulWidget {
// // //   final BetterPlayerController controller;
// // //   const PlayerOverlay({super.key, required this.controller});

// // //   @override
// // //   State<PlayerOverlay> createState() => _PlayerOverlayState();
// // // }

// // // class _PlayerOverlayState extends State<PlayerOverlay> {
// // //   bool showControls = true;
// // //   double currentSpeed = 1.0; // keep speed in local state
// // //   Duration position = Duration.zero;
// // //   Duration duration = Duration.zero;
// // //   Timer? _positionTimer;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     // Do NOT touch potentially-unstable getters like `isInitialized` or `getSpeed()`.
// // //     // We'll just keep our own currentSpeed (default 1.0) and update it when user changes speed.
// // //     _startPositionTimer();
// // //   }

// // //   void _startPositionTimer() {
// // //     _positionTimer?.cancel();
// // //     _positionTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
// // //       try {
// // //         final vpc = widget.controller.videoPlayerController;
// // //         if (vpc != null) {
// // //           // videoPlayerController.value has stable fields like position and duration.
// // //           final val = vpc.value;
// // //           setState(() {
// // //             position = val.position;
// // //             duration = val.duration ?? Duration.zero;
// // //           });
// // //         }
// // //       } catch (_) {
// // //         // ignore errors reading internal controller state
// // //       }
// // //     });
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _positionTimer?.cancel();
// // //     super.dispose();
// // //   }

// // //   void _togglePlay() async {
// // //     final isPlaying = await widget.controller.isPlaying() ?? false;
// // //     if (isPlaying) {
// // //       widget.controller.pause();
// // //     } else {
// // //       widget.controller.play();
// // //     }
// // //   }

// // //   void _seekTo(Duration d) => widget.controller.seekTo(d);

// // //   void _changeSpeed(double s) {
// // //     // setSpeed exists on BetterPlayerController
// // //     widget.controller.setSpeed(s);
// // //     setState(() => currentSpeed = s);
// // //   }

// // //   // NOTE: For true quality switching you need direct rendition URLs.
// // //   // Here we re-setup the same (or other) url as a simple approach.
// // //  void _changeQuality(String url) async {
// // //   if (url == 'auto') return;

// // //   // Access internal video player controller for volume
// // //   final oldVol = await widget.controller.videoPlayerController?.value.volume ?? 1.0;

// // //   await widget.controller.pause();
// // //   await widget.controller.setupDataSource(
// // //     BetterPlayerDataSource(
// // //       BetterPlayerDataSourceType.network,
// // //       url,
// // //       liveStream: true,
// // //     ),
// // //   );

// // //   // Restore volume
// // //   widget.controller.videoPlayerController?.setVolume(oldVol);
// // //   widget.controller.play();
// // // }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final maxMillis = duration.inMilliseconds > 0
// // //         ? duration.inMilliseconds.toDouble()
// // //         : (position.inMilliseconds + 1000).toDouble();

// // //     return GestureDetector(
// // //       onTap: () => setState(() => showControls = !showControls),
// // //       child: AnimatedOpacity(
// // //         opacity: showControls ? 1.0 : 0.0,
// // //         duration: const Duration(milliseconds: 200),
// // //         child: Container(
// // //           color: Colors.black26,
// // //           child: Column(
// // //             mainAxisAlignment: MainAxisAlignment.center,
// // //             children: [
// // //               // play/pause and center controls
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   IconButton(
// // //                     iconSize: 36,
// // //                     icon: const Icon(Icons.replay_10),
// // //                     onPressed: () {
// // //                       final newPos = position - const Duration(seconds: 10);
// // //                       _seekTo(newPos >= Duration.zero ? newPos : Duration.zero);
// // //                     },
// // //                   ),
// // //                  IconButton(
// // //   iconSize: 48,
// // //   icon: Icon(
// // //     widget.controller.videoPlayerController?.value.isPlaying ?? false
// // //         ? Icons.pause_circle_filled
// // //         : Icons.play_circle_filled,
// // //   ),
// // //   onPressed: _togglePlay,
// // // )
// // // ,
// // //                   IconButton(
// // //                     iconSize: 36,
// // //                     icon: const Icon(Icons.forward_10),
// // //                     onPressed: () {
// // //                       final newPos = position + const Duration(seconds: 10);
// // //                       _seekTo(newPos <= duration ? newPos : duration);
// // //                     },
// // //                   ),
// // //                 ],
// // //               ),

// // //               const SizedBox(height: 10),

// // //               // progress bar (seekable)
// // //               Padding(
// // //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// // //                 child: Column(
// // //                   children: [
// // //                     Slider(
// // //                       min: 0,
// // //                       max: maxMillis,
// // //                       value:
// // //                           position.inMilliseconds.toDouble().clamp(0, maxMillis),
// // //                       onChanged: (v) {
// // //                         final target = Duration(milliseconds: v.toInt());
// // //                         _seekTo(target);
// // //                       },
// // //                     ),
// // //                     Row(
// // //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                       children: [
// // //                         Text(_formatDuration(position)),
// // //                         Text(_formatDuration(duration)),
// // //                       ],
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),

// // //               const SizedBox(height: 8),

// // //               // speed & quality menus
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   PopupMenuButton<double>(
// // //                     tooltip: 'Speed',
// // //                     onSelected: _changeSpeed,
// // //                     itemBuilder: (_) => const [
// // //                       PopupMenuItem(value: 0.5, child: Text('0.5x')),
// // //                       PopupMenuItem(value: 0.75, child: Text('0.75x')),
// // //                       PopupMenuItem(value: 1.0, child: Text('1x')),
// // //                       PopupMenuItem(value: 1.25, child: Text('1.25x')),
// // //                       PopupMenuItem(value: 1.5, child: Text('1.5x')),
// // //                       PopupMenuItem(value: 2.0, child: Text('2x')),
// // //                     ],
// // //                     child: Padding(
// // //                       padding: const EdgeInsets.symmetric(horizontal: 12),
// // //                       child:
// // //                           Text('${currentSpeed}x', style: const TextStyle(fontSize: 16)),
// // //                     ),
// // //                   ),

// // //                   const SizedBox(width: 16),

// // //                   PopupMenuButton<String>(
// // //                     tooltip: 'Quality',
// // //                     onSelected: _changeQuality,
// // //                     itemBuilder: (c) => [
// // //                       const PopupMenuItem(value: 'auto', child: Text('Auto')),
// // //                       PopupMenuItem(
// // //                           value: widget.controller.betterPlayerDataSource?.url ?? 'auto',
// // //                           child: const Text('360p')),
// // //                       PopupMenuItem(
// // //                           value: widget.controller.betterPlayerDataSource?.url ?? 'auto',
// // //                           child: const Text('720p')),
// // //                       PopupMenuItem(
// // //                           value: widget.controller.betterPlayerDataSource?.url ?? 'auto',
// // //                           child: const Text('1080p')),
// // //                     ],
// // //                     child: const Padding(
// // //                       padding: EdgeInsets.symmetric(horizontal: 12),
// // //                       child: Text('Quality', style: TextStyle(fontSize: 16)),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),

// // //               const SizedBox(height: 8),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   String _formatDuration(Duration d) {
// // //     final h = d.inHours;
// // //     final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
// // //     final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
// // //     if (h > 0) return '$h:$m:$s';
// // //     return '$m:$s';
// // //   }
// // // }

// // // lib/widgets/player_overlay.dart
// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:better_player/better_player.dart';

// // class PlayerOverlay extends StatefulWidget {
// //   final BetterPlayerController controller;
// //   const PlayerOverlay({super.key, required this.controller});

// //   @override
// //   State<PlayerOverlay> createState() => _PlayerOverlayState();
// // }

// // class _PlayerOverlayState extends State<PlayerOverlay> {
// //   bool showControls = true;
// //   double currentSpeed = 1.0; // <-- track speed here
// //   Duration position = Duration.zero;
// //   Duration duration = Duration.zero;
// //   Timer? _positionTimer;

// //   @override
// //   void initState() {
// //     super.initState();
// //     // if you previously set some speed, you can attempt to read it from controller,
// //     // otherwise we keep the default 1.0
// //     _startPositionTimer();
// //   }

// //   void _startPositionTimer() {
// //     _positionTimer?.cancel();
// //     _positionTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
// //       try {
// //         final vpc = widget.controller.videoPlayerController;
// //         if (vpc != null) {
// //           final val = vpc.value;
// //           setState(() {
// //             position = val.position;
// //             duration = val.duration ?? Duration.zero;
// //           });
// //         }
// //       } catch (_) {
// //         // ignore any internal reads failing on some versions
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _positionTimer?.cancel();
// //     super.dispose();
// //   }

// //   void _togglePlay() async {
// //     final isPlaying =
// //         widget.controller.videoPlayerController?.value.isPlaying ?? false;
// //     if (isPlaying) {
// //       widget.controller.pause();
// //     } else {
// //       widget.controller.play();
// //     }
// //     // no need to setState here because periodic timer will update UI quickly,
// //     // but we can force small update for immediate feedback:
// //     setState(() {});
// //   }

// //   void _seekTo(Duration d) => widget.controller.seekTo(d);

// //   void _changeSpeed(double s) {
// //     // call BetterPlayer's API and update our state
// //     widget.controller.setSpeed(s);
// //     setState(() => currentSpeed = s);
// //   }

// //   void _changeQuality(String url) async {
// //     if (url == 'auto') return;
// //     // read volume via internal videoPlayerController (version-proof)
// //     final oldVol = widget.controller.videoPlayerController?.value.volume ?? 1.0;
// //     await widget.controller.pause();
// //     await widget.controller.setupDataSource(
// //       BetterPlayerDataSource(
// //         BetterPlayerDataSourceType.network,
// //         url,
// //         liveStream: true,
// //       ),
// //     );
// //     // restore volume (use internal API of video_player)
// //     try {
// //       await widget.controller.videoPlayerController?.setVolume(oldVol);
// //     } catch (_) {}
// //     widget.controller.play();
// //     // keep UI responsive
// //     setState(() {});
// //   }

// //   String _formatDuration(Duration d) {
// //     final h = d.inHours;
// //     final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
// //     final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
// //     if (h > 0) return '$h:$m:$s';
// //     return '$m:$s';
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final maxMillis = duration.inMilliseconds > 0
// //         ? duration.inMilliseconds.toDouble()
// //         : (position.inMilliseconds + 1000).toDouble();

// //     final isPlaying =
// //         widget.controller.videoPlayerController?.value.isPlaying ?? false;

// //     return GestureDetector(
// //       onTap: () => setState(() => showControls = !showControls),
// //       child: AnimatedOpacity(
// //         opacity: showControls ? 1.0 : 0.0,
// //         duration: const Duration(milliseconds: 200),
// //         child: Container(
// //           color: Colors.black26,
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               // Top: status + speed display
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(
// //                   horizontal: 12,
// //                   vertical: 6,
// //                 ),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(isPlaying ? 'Playing' : 'Paused'),
// //                     Text('${currentSpeed.toStringAsFixed(2)}x'),
// //                   ],
// //                 ),
// //               ),

// //               // Center controls (seek 10s, play/pause)
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   IconButton(
// //                     iconSize: 36,
// //                     icon: const Icon(Icons.replay_10),
// //                     onPressed: () {
// //                       final newPos = position - const Duration(seconds: 10);
// //                       _seekTo(newPos >= Duration.zero ? newPos : Duration.zero);
// //                     },
// //                   ),
// //                   IconButton(
// //                     iconSize: 48,
// //                     icon: Icon(
// //                       isPlaying
// //                           ? Icons.pause_circle_filled
// //                           : Icons.play_circle_filled,
// //                     ),
// //                     onPressed: _togglePlay,
// //                   ),
// //                   IconButton(
// //                     iconSize: 36,
// //                     icon: const Icon(Icons.forward_10),
// //                     onPressed: () {
// //                       final newPos = position + const Duration(seconds: 10);
// //                       _seekTo(newPos <= duration ? newPos : duration);
// //                     },
// //                   ),
// //                 ],
// //               ),

// //               const SizedBox(height: 10),

// //               // Progress slider
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 child: Column(
// //                   children: [
// //                     Slider(
// //                       min: 0,
// //                       max: maxMillis,
// //                       value: position.inMilliseconds.toDouble().clamp(
// //                         0,
// //                         maxMillis,
// //                       ),
// //                       onChanged: (v) {
// //                         final target = Duration(milliseconds: v.toInt());
// //                         _seekTo(target);
// //                       },
// //                     ),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Text(_formatDuration(position)),
// //                         Text(_formatDuration(duration)),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               const SizedBox(height: 8),

// //               // Speed and Quality menus
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   PopupMenuButton<double>(
// //                     tooltip: 'Speed',
// //                     onSelected: _changeSpeed,
// //                     itemBuilder: (_) => const [
// //                       PopupMenuItem(value: 0.5, child: Text('0.5x')),
// //                       PopupMenuItem(value: 0.75, child: Text('0.75x')),
// //                       PopupMenuItem(value: 1.0, child: Text('1x')),
// //                       PopupMenuItem(value: 1.25, child: Text('1.25x')),
// //                       PopupMenuItem(value: 1.5, child: Text('1.5x')),
// //                       PopupMenuItem(value: 2.0, child: Text('2x')),
// //                     ],
// //                     child: Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 12),
// //                       child: Text(
// //                         '${currentSpeed.toStringAsFixed(2)}x',
// //                         style: const TextStyle(fontSize: 16),
// //                       ),
// //                     ),
// //                   ),

// //                   const SizedBox(width: 16),

// //                   PopupMenuButton<String>(
// //                     tooltip: 'Quality',
// //                     onSelected: _changeQuality,
// //                     itemBuilder: (c) => [
// //                       const PopupMenuItem(value: 'auto', child: Text('Auto')),
// //                       PopupMenuItem(
// //                         value:
// //                             widget.controller.betterPlayerDataSource?.url ??
// //                             'auto',
// //                         child: const Text('360p'),
// //                       ),
// //                       PopupMenuItem(
// //                         value:
// //                             widget.controller.betterPlayerDataSource?.url ??
// //                             'auto',
// //                         child: const Text('720p'),
// //                       ),
// //                       PopupMenuItem(
// //                         value:
// //                             widget.controller.betterPlayerDataSource?.url ??
// //                             'auto',
// //                         child: const Text('1080p'),
// //                       ),
// //                     ],
// //                     child: const Padding(
// //                       padding: EdgeInsets.symmetric(horizontal: 12),
// //                       child: Text('Quality', style: TextStyle(fontSize: 16)),
// //                     ),
// //                   ),
// //                 ],
// //               ),

// //               const SizedBox(height: 8),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:better_player/better_player.dart';

// class PlayerOverlay extends StatefulWidget {
//   final BetterPlayerController controller;
//   const PlayerOverlay({super.key, required this.controller});

//   @override
//   State<PlayerOverlay> createState() => _PlayerOverlayState();
// }

// class _PlayerOverlayState extends State<PlayerOverlay> {
//   bool showControls = true;
//   double currentSpeed = 1.0;
//   Duration position = Duration.zero;
//   Duration duration = Duration.zero;
//   Timer? _positionTimer;

//   @override
//   void initState() {
//     super.initState();
//     _startPositionTimer();
//   }

//   void _startPositionTimer() {
//     _positionTimer?.cancel();
//     _positionTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
//       if (!mounted) return;
//       try {
//         final vpc = widget.controller.videoPlayerController;
//         if (vpc != null && vpc.value.duration != null) {
//           setState(() {
//             position = vpc.value.position;
//             duration = vpc.value.duration ?? Duration.zero;
//           });
//         }
//       } catch (_) {}
//     });
//   }

//   @override
//   void dispose() {
//     _positionTimer?.cancel();
//     try {
//       widget.controller.videoPlayerController?.removeListener(() {});
//     } catch (_) {}
//     super.dispose();
//   }

//   void _togglePlay() async {
//     final isPlaying =
//         widget.controller.videoPlayerController?.value.isPlaying ?? false;
//     if (isPlaying) {
//       await widget.controller.pause();
//     } else {
//       await widget.controller.play();
//     }
//     if (mounted) setState(() {});
//   }

//   void _seekTo(Duration d) {
//     if (mounted) widget.controller.seekTo(d);
//   }

//   void _changeSpeed(double s) {
//     widget.controller.setSpeed(s);
//     if (mounted) setState(() => currentSpeed = s);
//   }

//   void _changeQuality(String url) async {
//     if (url == 'auto') return;
//     final oldVol = widget.controller.videoPlayerController?.value.volume ?? 1.0;
//     await widget.controller.pause();
//     await widget.controller.setupDataSource(
//       BetterPlayerDataSource(
//         BetterPlayerDataSourceType.network,
//         url,
//         liveStream: true,
//       ),
//     );
//     try {
//       await widget.controller.videoPlayerController?.setVolume(oldVol);
//     } catch (_) {}
//     await widget.controller.play();
//     if (mounted) setState(() {});
//   }

//   String _formatDuration(Duration d) {
//     final h = d.inHours;
//     final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
//     if (h > 0) return '$h:$m:$s';
//     return '$m:$s';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final maxMillis = duration.inMilliseconds > 0
//         ? duration.inMilliseconds.toDouble()
//         : (position.inMilliseconds + 1000).toDouble();
//     final isPlaying =
//         widget.controller.videoPlayerController?.value.isPlaying ?? false;

//     return GestureDetector(
//       onTap: () => setState(() => showControls = !showControls),
//       child: AnimatedOpacity(
//         opacity: showControls ? 1.0 : 0.0,
//         duration: const Duration(milliseconds: 200),
//         child: Container(
//           color: Colors.black26,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(isPlaying ? 'Playing' : 'Paused'),
//                     Text('${currentSpeed.toStringAsFixed(2)}x'),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     iconSize: 36,
//                     icon: const Icon(Icons.replay_10),
//                     onPressed: () {
//                       final newPos = position - const Duration(seconds: 10);
//                       _seekTo(newPos >= Duration.zero ? newPos : Duration.zero);
//                     },
//                   ),
//                   IconButton(
//                     iconSize: 48,
//                     icon: Icon(
//                       isPlaying
//                           ? Icons.pause_circle_filled
//                           : Icons.play_circle_filled,
//                     ),
//                     onPressed: _togglePlay,
//                   ),
//                   IconButton(
//                     iconSize: 36,
//                     icon: const Icon(Icons.forward_10),
//                     onPressed: () {
//                       final newPos = position + const Duration(seconds: 10);
//                       _seekTo(newPos <= duration ? newPos : duration);
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   children: [
//                     Slider(
//                       min: 0,
//                       max: maxMillis,
//                       value: position.inMilliseconds.toDouble().clamp(
//                         0,
//                         maxMillis,
//                       ),
//                       onChanged: (v) {
//                         final target = Duration(milliseconds: v.toInt());
//                         _seekTo(target);
//                       },
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(_formatDuration(position)),
//                         Text(_formatDuration(duration)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   PopupMenuButton<double>(
//                     tooltip: 'Speed',
//                     onSelected: _changeSpeed,
//                     itemBuilder: (_) => const [
//                       PopupMenuItem(value: 0.5, child: Text('0.5x')),
//                       PopupMenuItem(value: 0.75, child: Text('0.75x')),
//                       PopupMenuItem(value: 1.0, child: Text('1x')),
//                       PopupMenuItem(value: 1.25, child: Text('1.25x')),
//                       PopupMenuItem(value: 1.5, child: Text('1.5x')),
//                       PopupMenuItem(value: 2.0, child: Text('2x')),
//                     ],
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Text(
//                         '${currentSpeed.toStringAsFixed(2)}x',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   PopupMenuButton<String>(
//                     tooltip: 'Quality',
//                     onSelected: _changeQuality,
//                     itemBuilder: (c) => [
//                       const PopupMenuItem(value: 'auto', child: Text('Auto')),
//                       PopupMenuItem(
//                         value:
//                             widget.controller.betterPlayerDataSource?.url ??
//                             'auto',
//                         child: const Text('360p'),
//                       ),
//                       PopupMenuItem(
//                         value:
//                             widget.controller.betterPlayerDataSource?.url ??
//                             'auto',
//                         child: const Text('720p'),
//                       ),
//                       PopupMenuItem(
//                         value:
//                             widget.controller.betterPlayerDataSource?.url ??
//                             'auto',
//                         child: const Text('1080p'),
//                       ),
//                     ],
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 12),
//                       child: Text('Quality', style: TextStyle(fontSize: 16)),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 28),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class PlayerOverlay extends StatefulWidget {
  final BetterPlayerController controller;
  const PlayerOverlay({super.key, required this.controller});

  @override
  State<PlayerOverlay> createState() => _PlayerOverlayState();
}

class _PlayerOverlayState extends State<PlayerOverlay> {
  bool showControls = true;
  double currentSpeed = 1.0;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  Timer? _positionTimer;

  @override
  void initState() {
    super.initState();
    _startPositionTimer();
  }

  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;
      try {
        final vpc = widget.controller.videoPlayerController;
        if (vpc != null && vpc.value.duration != null) {
          setState(() {
            position = vpc.value.position;
            duration = vpc.value.duration ?? Duration.zero;
          });
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _positionTimer?.cancel();
    super.dispose();
  }

  void _togglePlay() async {
    final isPlaying =
        widget.controller.videoPlayerController?.value.isPlaying ?? false;
    if (isPlaying) {
      await widget.controller.pause();
    } else {
      await widget.controller.play();
    }
    if (mounted) setState(() {});
  }

  void _seekTo(Duration d) {
    if (mounted) widget.controller.seekTo(d);
  }

  void _changeSpeed(double s) {
    widget.controller.setSpeed(s);
    if (mounted) setState(() => currentSpeed = s);
  }

  void _changeQuality(String url) async {
    if (url == 'auto') return;
    final oldVol = widget.controller.videoPlayerController?.value.volume ?? 1.0;
    await widget.controller.pause();
    await widget.controller.setupDataSource(
      BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        url,
        liveStream: true,
      ),
    );
    try {
      await widget.controller.videoPlayerController?.setVolume(oldVol);
    } catch (_) {}
    await widget.controller.play();
    if (mounted) setState(() {});
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (h > 0) return '$h:$m:$s';
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final maxMillis = duration.inMilliseconds > 0
        ? duration.inMilliseconds.toDouble()
        : (position.inMilliseconds + 1000).toDouble();
    final isPlaying =
        widget.controller.videoPlayerController?.value.isPlaying ?? false;

    return GestureDetector(
      onTap: () => setState(() => showControls = !showControls),
      child: AnimatedOpacity(
        opacity: showControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          color: Colors.black26,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: SafeArea(
            // ✅ Fixes overflow on bottom
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isPlaying ? 'Playing' : 'Paused',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${currentSpeed.toStringAsFixed(2)}x',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 36,
                      color: Colors.white,
                      icon: const Icon(Icons.replay_10),
                      onPressed: () {
                        final newPos = position - const Duration(seconds: 10);
                        _seekTo(
                          newPos >= Duration.zero ? newPos : Duration.zero,
                        );
                      },
                    ),
                    IconButton(
                      iconSize: 48,
                      color: Colors.white,
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                      ),
                      onPressed: _togglePlay,
                    ),
                    IconButton(
                      iconSize: 36,
                      color: Colors.white,
                      icon: const Icon(Icons.forward_10),
                      onPressed: () {
                        final newPos = position + const Duration(seconds: 10);
                        _seekTo(newPos <= duration ? newPos : duration);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Column(
                    children: [
                      Slider(
                        min: 0,
                        max: maxMillis,
                        value: position.inMilliseconds.toDouble().clamp(
                          0,
                          maxMillis,
                        ),
                        onChanged: (v) {
                          final target = Duration(milliseconds: v.toInt());
                          _seekTo(target);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            _formatDuration(duration),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PopupMenuButton<double>(
                      tooltip: 'Speed',
                      onSelected: _changeSpeed,
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 0.5, child: Text('0.5x')),
                        PopupMenuItem(value: 0.75, child: Text('0.75x')),
                        PopupMenuItem(value: 1.0, child: Text('1x')),
                        PopupMenuItem(value: 1.25, child: Text('1.25x')),
                        PopupMenuItem(value: 1.5, child: Text('1.5x')),
                        PopupMenuItem(value: 2.0, child: Text('2x')),
                      ],
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Speed',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    PopupMenuButton<String>(
                      tooltip: 'Quality',
                      onSelected: _changeQuality,
                      itemBuilder: (c) => [
                        const PopupMenuItem(value: 'auto', child: Text('Auto')),
                        const PopupMenuItem(value: '360', child: Text('360p')),
                        const PopupMenuItem(value: '720', child: Text('720p')),
                        const PopupMenuItem(
                          value: '1080',
                          child: Text('1080p'),
                        ),
                      ],
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Quality',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
