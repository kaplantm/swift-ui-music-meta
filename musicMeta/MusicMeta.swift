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
    let fileManager = FileManager.default
    private let fileName = "musicMeta.csv"

    static var isMusicAuthorized : Bool = false;
    var songData : [[String : Any]] = []
    
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
//           let songData = generateSongData()
           let foo = "getSongList()"
            saveToFiles(foo)
           print(foo)
        }
        else{
            requestMusicAuth(generateMeta)
        }
    }
    
    func generateSongData() {
      let myPlaylistQuery = MPMediaQuery.songs()
      let items : [MPMediaItem] = myPlaylistQuery.items ?? []

        self.songData = items.map { [
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
    }

    func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
   func saveToFiles(_ data: String) {
       // Where we will write our data to. This early exits if it fails to get the directory.
       guard let docDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
       else { return }
        do {
            try data.write(to: docDirectoryURL.appendingPathComponent(self.fileName), atomically: true, encoding: String.Encoding.utf8)
        } catch {
          // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
          print("failed to saved")
        }
   }
    
    
    func export() {
        print("export")
    }
}
