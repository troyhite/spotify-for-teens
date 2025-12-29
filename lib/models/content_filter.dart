import 'track.dart';

/// Content rating levels
enum ContentRating {
  everyone(0),
  teen(1),
  mature(2),
  explicit(3);

  final int value;
  const ContentRating(this.value);
}

/// Content filter configuration
class ContentFilter {
  final ContentRating maxRating;
  final bool blockExplicitContent;
  final List<String> blockedKeywords;
  final List<String>? allowedGenres;

  const ContentFilter({
    required this.maxRating,
    required this.blockExplicitContent,
    required this.blockedKeywords,
    this.allowedGenres,
  });

  /// Default filter for teens (13+)
  static const defaultFilter = ContentFilter(
    maxRating: ContentRating.teen,
    blockExplicitContent: true,
    blockedKeywords: [],
    allowedGenres: null,
  );

  /// Strict filter for everyone
  static const strict = ContentFilter(
    maxRating: ContentRating.everyone,
    blockExplicitContent: true,
    blockedKeywords: ['drug', 'violence', 'explicit'],
    allowedGenres: ['pop', 'rock', 'indie', 'electronic', 'classical'],
  );

  /// Check if content is allowed based on filter rules
  bool isContentAllowed(Track track) {
    // Block explicit content if setting is enabled
    if (blockExplicitContent && track.isExplicit) {
      return false;
    }

    // Check for blocked keywords in track name
    final trackNameLower = track.name.toLowerCase();
    for (final keyword in blockedKeywords) {
      if (trackNameLower.contains(keyword.toLowerCase())) {
        return false;
      }
    }

    // Check for blocked keywords in artist names
    final artistNameLower = track.artistNames.toLowerCase();
    for (final keyword in blockedKeywords) {
      if (artistNameLower.contains(keyword.toLowerCase())) {
        return false;
      }
    }

    return true;
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'maxRating': maxRating.value,
      'blockExplicitContent': blockExplicitContent,
      'blockedKeywords': blockedKeywords,
      'allowedGenres': allowedGenres,
    };
  }

  /// Deserialize from JSON
  factory ContentFilter.fromJson(Map<String, dynamic> json) {
    return ContentFilter(
      maxRating: ContentRating.values[json['maxRating'] ?? 1],
      blockExplicitContent: json['blockExplicitContent'] ?? true,
      blockedKeywords: List<String>.from(json['blockedKeywords'] ?? []),
      allowedGenres: json['allowedGenres'] != null
          ? List<String>.from(json['allowedGenres'])
          : null,
    );
  }

  /// Create a copy with some fields updated
  ContentFilter copyWith({
    ContentRating? maxRating,
    bool? blockExplicitContent,
    List<String>? blockedKeywords,
    List<String>? allowedGenres,
  }) {
    return ContentFilter(
      maxRating: maxRating ?? this.maxRating,
      blockExplicitContent: blockExplicitContent ?? this.blockExplicitContent,
      blockedKeywords: blockedKeywords ?? this.blockedKeywords,
      allowedGenres: allowedGenres ?? this.allowedGenres,
    );
  }
}
