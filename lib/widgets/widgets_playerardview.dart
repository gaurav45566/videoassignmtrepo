import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'player_overlay.dart';

class PlayerCard extends StatelessWidget {
  final int index;
  final BetterPlayerController controller;
  final String title;
  final void Function(bool visible) onVisibilityChanged;

  const PlayerCard({
    super.key,
    required this.index,
    required this.controller,
    required this.title,
    required this.onVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20), // gap between cards
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24), // extra bottom padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_off),
                      onPressed: () => controller.setVolume(0),
                      tooltip: 'Mute',
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: () => controller.setVolume(1),
                      tooltip: 'Unmute',
                    ),
                  ],
                ),
              ),

              // video + overlay
              VisibilityDetector(
                key: Key('player-$index'),
                onVisibilityChanged: (info) {
                  final visible = info.visibleFraction > 0.15;
                  onVisibilityChanged(visible);
                },
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    children: [
                      BetterPlayer(controller: controller),
                      Positioned.fill(
                        child: PlayerOverlay(controller: controller),
                      ),
                    ],
                  ),
                ),
              ),

              // footer
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (controller.videoPlayerController?.value.isPlaying ??
                              false)
                          ? 'Playing'
                          : 'Paused',
                    ),
                    const Text('Speed: 1.0x'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
