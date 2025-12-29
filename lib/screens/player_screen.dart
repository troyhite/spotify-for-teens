import 'package:flutter/material.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  final double _duration = 100.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Album art
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.music_note,
                size: 100,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 40),

            // Track info
            const Text(
              'No track playing',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              '',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Progress bar
            Column(
              children: [
                Slider(
                  value: _currentPosition,
                  max: _duration,
                  onChanged: (value) {
                    setState(() => _currentPosition = value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_currentPosition.toInt()),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        _formatDuration(_duration.toInt()),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Playback controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  iconSize: 48,
                  onPressed: () {
                    // Previous track
                  },
                ),
                
                const SizedBox(width: 20),
                
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    iconSize: 48,
                    color: Colors.white,
                    onPressed: () {
                      setState(() => _isPlaying = !_isPlaying);
                    },
                  ),
                ),
                
                const SizedBox(width: 20),
                
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  iconSize: 48,
                  onPressed: () {
                    // Next track
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }
}
