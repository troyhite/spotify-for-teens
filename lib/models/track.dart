/// Track model representing a Spotify track
class Track {
  final String id;
  final String name;
  final List<Artist> artists;
  final Album album;
  final int durationMs;
  final bool isExplicit;
  final String uri;
  final String? previewUrl;

  Track({
    required this.id,
    required this.name,
    required this.artists,
    required this.album,
    required this.durationMs,
    required this.isExplicit,
    required this.uri,
    this.previewUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      artists: (json['artists'] as List<dynamic>?)
              ?.map((a) => Artist.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      album: Album.fromJson(json['album'] as Map<String, dynamic>? ?? {}),
      durationMs: json['duration_ms'] ?? 0,
      isExplicit: json['explicit'] ?? false,
      uri: json['uri'] ?? '',
      previewUrl: json['preview_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'artists': artists.map((a) => a.toJson()).toList(),
      'album': album.toJson(),
      'duration_ms': durationMs,
      'explicit': isExplicit,
      'uri': uri,
      'preview_url': previewUrl,
    };
  }

  String get artistNames => artists.map((a) => a.name).join(', ');

  String get durationFormatted {
    final minutes = durationMs ~/ 60000;
    final seconds = (durationMs % 60000) ~/ 1000;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Artist model
class Artist {
  final String id;
  final String name;

  Artist({
    required this.id,
    required this.name,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

/// Album model
class Album {
  final String id;
  final String name;
  final List<SpotifyImage> images;
  final String? releaseDate;

  Album({
    required this.id,
    required this.name,
    required this.images,
    this.releaseDate,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((i) => SpotifyImage.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      releaseDate: json['release_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'images': images.map((i) => i.toJson()).toList(),
      'release_date': releaseDate,
    };
  }

  String? get imageUrl {
    if (images.isEmpty) return null;
    return images.first.url;
  }
}

/// Spotify image model
class SpotifyImage {
  final String url;
  final int? height;
  final int? width;

  SpotifyImage({
    required this.url,
    this.height,
    this.width,
  });

  factory SpotifyImage.fromJson(Map<String, dynamic> json) {
    return SpotifyImage(
      url: json['url'] ?? '',
      height: json['height'],
      width: json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'height': height,
      'width': width,
    };
  }
}

/// Playlist model
class Playlist {
  final String id;
  final String name;
  final String? description;
  final List<SpotifyImage> images;

  Playlist({
    required this.id,
    required this.name,
    this.description,
    required this.images,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      images: (json['images'] as List<dynamic>?)
              ?.map((i) => SpotifyImage.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images.map((i) => i.toJson()).toList(),
    };
  }

  String? get imageUrl {
    if (images.isEmpty) return null;
    return images.first.url;
  }
}
