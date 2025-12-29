import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/track.dart';
import '../services/spotify_service.dart';
import '../services/parental_controls_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Track> _tracks = [];
  List<Track> _filteredTracks = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchTracks(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _tracks = [];
        _filteredTracks = [];
      });
      return;
    }

    setState(() => _isLoading = true);

    final spotify = context.read<SpotifyService>();
    final tracks = await spotify.searchTracks(query);

    if (mounted) {
      setState(() {
        _tracks = tracks;
        _filterTracks();
        _isLoading = false;
      });
    }
  }

  void _filterTracks() {
    final parentalControls = context.read<ParentalControlsService>();
    final filter = parentalControls.currentFilter;
    
    _filteredTracks = _tracks.where((track) => filter.isContentAllowed(track)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search for songs',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            // Debounce search
            Future.delayed(const Duration(milliseconds: 500), () {
              if (_searchController.text == value) {
                _searchTracks(value);
              }
            });
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredTracks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchController.text.isEmpty
                            ? 'Search for music'
                            : 'No results found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (_tracks.isNotEmpty && _filteredTracks.isEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          '${_tracks.length} tracks filtered by parental controls',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredTracks.length,
                  itemBuilder: (context, index) {
                    final track = _filteredTracks[index];
                    return TrackListItem(track: track);
                  },
                ),
    );
  }
}

class TrackListItem extends StatelessWidget {
  final Track track;

  const TrackListItem({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: track.album.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: track.album.imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child: const Icon(Icons.music_note, size: 24),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child: const Icon(Icons.music_note, size: 24),
                ),
              )
            : Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: const Icon(Icons.music_note, size: 24),
              ),
      ),
      title: Text(
        track.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        track.artistNames,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        track.durationFormatted,
        style: TextStyle(color: Colors.grey[600]),
      ),
      onTap: () {
        // Handle track play
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Playing: ${track.name}')),
        );
      },
    );
  }
}
