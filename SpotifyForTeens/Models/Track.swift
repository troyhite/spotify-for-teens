//
//  Track.swift
//  SpotifyForTeens
//
//  Created on 2025-12-29
//

import Foundation

struct Track: Codable {
    let id: String
    let name: String
    let artists: [Artist]
    let album: Album
    let durationMs: Int
    let isExplicit: Bool
    let uri: String
    let previewUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, artists, album, uri
        case durationMs = "duration_ms"
        case isExplicit = "explicit"
        case previewUrl = "preview_url"
    }
    
    var artistNames: String {
        artists.map { $0.name }.joined(separator: ", ")
    }
    
    var durationFormatted: String {
        let minutes = durationMs / 60000
        let seconds = (durationMs % 60000) / 1000
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct Artist: Codable {
    let id: String
    let name: String
}

struct Album: Codable {
    let id: String
    let name: String
    let images: [SpotifyImage]
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, images
        case releaseDate = "release_date"
    }
}

struct SpotifyImage: Codable {
    let url: String
    let height: Int?
    let width: Int?
}
