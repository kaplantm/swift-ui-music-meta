//
//  SongItem.swift
//  musicMeta
//
//  Created by Toni Kaplan on 6/7/20.
//  Copyright © 2020 Toni Kaplan. All rights reserved.
//

import Foundation
import MediaPlayer

class SongItem {
    let title: String?
    let artist: String?
    let albumTitle: String?
    let playCount: Int
    let dateAdded: Date
    let genre: String?
    let beatsPerMinute: Int
    let playbackDuration: Double
    let skipCount: Int
    let isExplicitItem: Bool
    let releaseDate: Date?
    let isCloudItem: Bool
    let artistPersistentID: MPMediaEntityPersistentID
    let persistentID: MPMediaEntityPersistentID
    let genrePersistentID: MPMediaEntityPersistentID
    
    let df = DateFormatter()
    
    init(song: MPMediaItem) {
        title = song.title
        artist = song.artist
        albumTitle = song.albumTitle
        playCount = song.playCount
        dateAdded = song.dateAdded
        genre = song.genre
        beatsPerMinute = song.beatsPerMinute
        playbackDuration = song.playbackDuration
        skipCount = song.skipCount
        isExplicitItem = song.isExplicitItem
        releaseDate = song.releaseDate
        isCloudItem = song.isCloudItem
        artistPersistentID = song.artistPersistentID
        persistentID = song.persistentID
        genrePersistentID = song.genrePersistentID
    }
    
    var stringDict: [String:String] {
        df.dateFormat = "yyyy-MM-dd"
        return [
            "title": String(title ?? ""),
            "artist": String(artist ?? ""),
            "albumTitle": String(albumTitle ?? ""),
            "playCount": String(playCount),
            "dateAdded": df.string(from: dateAdded),
            "genre": String(genre ?? ""),
            "beatsPerMinute": String(beatsPerMinute),
            "playbackDuration": String(playbackDuration),
            "skipCount": String(skipCount),
            "isExplicitItem": String(isExplicitItem),
            "releaseDate": releaseDate != nil ? df.string(from: releaseDate!) : "",
            "isCloudItem": String(isCloudItem),
            "artistPersistentID": String(artistPersistentID),
            "persistentID": String(persistentID),
            "genrePersistentID": String(genrePersistentID),
        ]
    }
    
    func asFieldsArray(fields:[String]) -> [String]{
        fields.map{field in
            if(stringDict[field] != nil){
                return stringDict[field]!
            }
            return ""
        }
    }
}
