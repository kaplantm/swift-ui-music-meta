//
//  MusicMeta.swift
//  musicMeta
//
//  Created by Toni Kaplan on 6/7/20.
//  Copyright © 2020 Toni Kaplan. All rights reserved.
//

import Foundation
import MediaPlayer

class MusicMeta {
    
    static var isMusicAuthorized : Bool = false;
    
    func requestMusicAuth(_ callback: @escaping ()->()) {
        let status : MPMediaLibraryAuthorizationStatus = MPMediaLibrary.authorizationStatus()
       
       if(status == .notDetermined){
        MPMediaLibrary.requestAuthorization() { newStatus in
            MusicMeta.isMusicAuthorized = newStatus == .authorized
            callback()
           }
       }
       else{
        MusicMeta.isMusicAuthorized = status == .authorized
        callback()
       }
    }
    
    func generateMeta(){
        if(MusicMeta.isMusicAuthorized == true){
//           let songData = getSongList()
           let songData = "getSongList()"
           print(songData)
        }
        else{
            requestMusicAuth(generateMeta)
        }
    }
    
    func getSongList() -> [[String : Any]] {
      let myPlaylistQuery = MPMediaQuery.songs()
      let items : [MPMediaItem] = myPlaylistQuery.items ?? []

      let itemData = items.map { [
        "title": $0.title as Any,
        "artist": $0.artist as Any,
        "albumTitle": $0.albumTitle as Any,
        "playCount":$0.playCount,
        "dateAdded":$0.dateAdded,
        "genre":$0.genre as Any,
        "beatsPerMinute":$0.beatsPerMinute,
        "playbackDuration":$0.playbackDuration,
        "skipCount":$0.skipCount,
        "isExplicitItem":$0.isExplicitItem,
        "mediaType":$0.mediaType,
        "releaseDate":$0.releaseDate as Any,
        "isCloudItem":$0.isCloudItem,
        "artistPersistentID":$0.artistPersistentID,
        "persistentID":$0.persistentID,
        "genrePersistentID":$0.genrePersistentID
        ] as [String:Any]}
      
      return itemData;
    }

}
