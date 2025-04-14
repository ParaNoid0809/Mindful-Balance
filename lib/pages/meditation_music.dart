import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as Rx;
import 'package:mindfulbalance/models/music_player_state.dart';
import 'package:flutter/services.dart' show DefaultAssetBundle;
import 'package:flutter/rendering.dart';
import 'dart:typed_data' show ByteData;

class MeditationMusicPage extends StatefulWidget {
  const MeditationMusicPage({super.key});

  @override
  State<MeditationMusicPage> createState() => _MeditationMusicPageState();
}

class _MeditationMusicPageState extends State<MeditationMusicPage> {
  late AudioPlayer _player;
  late List<MeditationTrack> _tracks;
  int? _currentTrackIndex;
  // ignore: unused_field
  double _volume = 1.0;
  String? _currentTrack;
  bool _isPlaying = false;

  Stream<MusicPlayerState> get _musicPlayerStateStream =>
      Rx.CombineLatestStream.combine5<
        Duration,
        double,
        int?,
        Duration?,
        List<IndexedAudioSource>?,
        MusicPlayerState
      >(
        _player.positionStream,
        _player.volumeStream,
        _player.currentIndexStream,
        _player.durationStream,
        _player.sequenceStream,
        (position, volume, currentIndex, duration, sequence) =>
            MusicPlayerState(
              player: _player,
              tracks: _tracks,
              currentTrackIndex: currentIndex,
              isPlaying: _player.playing,
              position: position,
              duration: duration ?? Duration.zero,
              volume: volume,
            ),
      );

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _setupAudioPlayer();
    _tracks = [
      MeditationTrack(
        title: "Peaceful Rain",
        assetPath: "assets/meditation/nature/peaceful_rain.mp3",
        duration: const Duration(minutes: 5, seconds: 30),
        icon: Icons.water_drop,
        category: "Nature Sounds",
      ),
      MeditationTrack(
        title: "Ocean Waves",
        assetPath: "assets/meditation/nature/ocean_waves.mp3",
        duration: const Duration(minutes: 6),
        icon: Icons.waves,
        category: "Nature Sounds",
      ),
      MeditationTrack(
        title: "Forest Birds",
        assetPath: "assets/meditation/nature/forest_birds.mp3",
        duration: const Duration(minutes: 4, seconds: 45),
        icon: Icons.forest,
        category: "Nature Sounds",
      ),
      MeditationTrack(
        title: "Zen Garden",
        assetPath: "assets/meditation/ambient/zen_garden.mp3",
        duration: const Duration(minutes: 7, seconds: 15),
        icon: Icons.spa,
        category: "Meditation",
      ),
      MeditationTrack(
        title: "Deep Relaxation",
        assetPath: "assets/meditation/ambient/deep_relaxation.mp3",
        duration: const Duration(minutes: 10),
        icon: Icons.self_improvement,
        category: "Meditation",
      ),
      MeditationTrack(
        title: "Healing Bells",
        assetPath: "assets/meditation/instruments/healing_bells.mp3",
        duration: const Duration(minutes: 5),
        icon: Icons.music_note,
        category: "Instruments",
      ),
    ];
  }

  void _setupAudioPlayer() {
    _player.playbackEventStream.listen(
      (event) {
        print('Playback event: $event');
      },
      onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
      },
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Future<void> _playTrack(String trackPath) async {
    try {
      // Check if the asset exists and get its size
      final ByteData data = await DefaultAssetBundle.of(
        context,
      ).load(trackPath);
      print('Asset size for $trackPath: ${data.lengthInBytes} bytes');

      if (data.lengthInBytes == 0) {
        throw Exception('Audio file is empty');
      }

      // Stop current track if playing
      await _player.stop();

      // Set the asset source
      await _player.setAsset(trackPath);
      await _player.setVolume(_volume);
      await _player.play();

      setState(() {
        _currentTrack = trackPath;
        _isPlaying = true;
      });
    } catch (e) {
      print('Error playing track: $e');
      setState(() {
        _isPlaying = false;
      });

      // Show a more informative error message to the user
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to play the audio file. Please ensure:\n'
            '1. The file exists at: $trackPath\n'
            '2. The file is a valid audio format (MP3)\n'
            '3. The file is correctly added to pubspec.yaml',
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Music'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Audio Files Required'),
                      content: const Text(
                        'To use this feature, you need to add meditation audio files to the following directories:\n\n'
                        '• assets/meditation/nature/\n'
                        '• assets/meditation/ambient/\n'
                        '• assets/meditation/instruments/\n\n'
                        'You can find free meditation sounds from:\n'
                        '• Pixabay Music\n'
                        '• Free Sound\n'
                        '• ccMixter\n\n'
                        'Make sure to name the files exactly as shown in the app.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<MusicPlayerState>(
        stream: _musicPlayerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;

          return Column(
            children: [
              // Currently playing section with progress bar
              if (playerState?.currentTrackIndex != null)
                Container(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            _tracks[playerState!.currentTrackIndex!].icon,
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _tracks[playerState.currentTrackIndex!].title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _tracks[playerState.currentTrackIndex!]
                                      .category,
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              playerState.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            onPressed: () {
                              if (playerState.isPlaying) {
                                _player.pause();
                              } else {
                                _playTrack(
                                  _tracks[playerState.currentTrackIndex!]
                                      .assetPath,
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.stop),
                            onPressed: () {
                              _player.stop();
                              setState(() => _currentTrackIndex = null);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Progress bar
                      Column(
                        children: [
                          Slider(
                            value:
                                playerState.position.inMilliseconds.toDouble(),
                            max: playerState.duration.inMilliseconds.toDouble(),
                            onChanged: (value) {
                              _player.seek(
                                Duration(milliseconds: value.toInt()),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatDuration(playerState.position)),
                                Text(_formatDuration(playerState.duration)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Volume control
                      Row(
                        children: [
                          const Icon(Icons.volume_down),
                          Expanded(
                            child: Slider(
                              value: playerState.volume,
                              onChanged: (value) {
                                _player.setVolume(value);
                                setState(() => _volume = value);
                              },
                            ),
                          ),
                          const Icon(Icons.volume_up),
                        ],
                      ),
                    ],
                  ),
                ),
              // Tracks list
              Expanded(
                child: ListView.builder(
                  itemCount: _tracks.length,
                  itemBuilder: (context, index) {
                    final track = _tracks[index];
                    final isPlaying =
                        playerState?.currentTrackIndex == index &&
                        playerState?.isPlaying == true;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: Icon(
                          track.icon,
                          color:
                              isPlaying ? Theme.of(context).primaryColor : null,
                        ),
                        title: Text(
                          track.title,
                          style: TextStyle(
                            fontWeight:
                                isPlaying ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(track.category),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_formatDuration(track.duration)),
                            const SizedBox(width: 8),
                            Icon(
                              isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              color:
                                  isPlaying
                                      ? Theme.of(context).primaryColor
                                      : null,
                            ),
                          ],
                        ),
                        onTap: () => _playTrack(track.assetPath),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
