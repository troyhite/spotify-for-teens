import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/track.dart';
import '../services/spotify_service.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  List<Playlist> _playlists = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    setState(() => _isLoading = true);

    final spotify = context.read<SpotifyService>();
    final playlists = await spotify.getFeaturedPlaylists();

    if (mounted) {
      setState(() {
        _playlists = playlists;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _playlists.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.library_music_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No playlists available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPlaylists,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPlaylists,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = _playlists[index];
                      return PlaylistCard(playlist: playlist);
                    },
                  ),
                ),
    );
  }
}

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;

  const PlaylistCard({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Navigate to playlist details
          // Navigator.push(context, MaterialPageRoute(...));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Playlist image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: playlist.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: playlist.imageUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.music_note),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.music_note),
                        ),
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.music_note),
                      ),
              ),
              
              const SizedBox(width: 12),
              
              // Playlist info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (playlist.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        playlist.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
