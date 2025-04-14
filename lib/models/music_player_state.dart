import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MeditationTrack {
  final String title;
  final String assetPath;
  final Duration duration;
  final IconData icon;
  final String category;

  MeditationTrack({
    required this.title,
    required this.assetPath,
    required this.duration,
    required this.icon,
    required this.category,
  });
}

class MusicPlayerState {
  final AudioPlayer player;
  final List<MeditationTrack> tracks;
  int? currentTrackIndex;
  bool isPlaying;
  Duration position;
  Duration duration;
  double volume;

  MusicPlayerState({
    required this.player,
    required this.tracks,
    this.currentTrackIndex,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.volume = 1.0,
  });

  MusicPlayerState copyWith({
    AudioPlayer? player,
    List<MeditationTrack>? tracks,
    int? currentTrackIndex,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    double? volume,
  }) {
    return MusicPlayerState(
      player: player ?? this.player,
      tracks: tracks ?? this.tracks,
      currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
    );
  }
}
