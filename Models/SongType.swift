//
//  song.swift
//  musicMeta
//
//  Created by Toni Kaplan on 6/7/20.
//  Copyright © 2020 Toni Kaplan. All rights reserved.
//

import Foundation

struct SongType: Hashable, Codable {
    let title: String
    let artist: String
    let albumTitle: String
    let playCount: Int
    let dateAdded: Date
    let genre: String
    let beatsPerMinute: Int
    let playbackDuration: Double
    let skipCount: Int
    let isExplicitItem: String
    let releaseDate: Date?
    let isCloudItem: String
    let artistPersistentID: String
    let persistentID: String
    let genrePersistentID: String
}
