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
    var savedFileLocation : URL? = nil
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
            generateSongData()
            let formattedData = formatSongData()
            print(formattedData)
            saveToFiles(formattedData)
        }
        else{
            requestMusicAuth(generateMeta)
        }
    }
    
    func generateSongData() {
      let myPlaylistQuery = MPMediaQuery.songs()
      let items : [MPMediaItem] = myPlaylistQuery.items ?? []

        self.songData = items.map { [
        "title": $0.title ?? "" as String,
        "artist": $0.artist ?? "" as String,
        "albumTitle": $0.albumTitle ?? "" as String,
        "playCount":$0.playCount,
        "dateAdded":$0.dateAdded,
        "genre":$0.genre ?? "" as String,
        "beatsPerMinute":$0.beatsPerMinute,
        "playbackDuration":$0.playbackDuration,
        "skipCount":$0.skipCount,
        "isExplicitItem":$0.isExplicitItem,
        "releaseDate":$0.releaseDate ?? "" as Any,
        "isCloudItem":$0.isCloudItem,
        "artistPersistentID":$0.artistPersistentID,
        "persistentID":$0.persistentID,
        "genrePersistentID":$0.genrePersistentID
        ] as [String:Any]}
    }
    
    func getSongAttr(song:[String:Any?], attr:String) -> String {
        return "\"\(String(describing: (song[attr] ?? "")!))\""
    }
    
    func formatSongData() -> String{
        var csvString = "\("Title"),\("Artist"),\("AlbumTitle"),\("PlayCount"),\("dateAdded"),\("genre"),\("beatsPerMinute"),\("playbackDuration"),\("skipCount"),\("isExplicitItem"),\("releaseDate"),\("isCloudItem"),\("artistPersistentID"),\("persistentID"),\("genrePersistentID")\n\n"
        
        let comma : String = ","
        for song in self.songData {
           csvString = csvString.appending("\(getSongAttr(song: song, attr: "title")+comma+getSongAttr(song: song, attr: "artist")+comma+getSongAttr(song: song, attr: "albumTitle")+comma+getSongAttr(song: song, attr: "playCount")+comma+getSongAttr(song: song, attr: "dateAdded")+comma+getSongAttr(song: song, attr: "genre")+comma+getSongAttr(song: song, attr: "beatsPerMinute")+comma+getSongAttr(song: song, attr: "playbackDuration")+comma+getSongAttr(song: song, attr: "skipCount")+comma+getSongAttr(song: song, attr: "isExplicitItem")+comma+getSongAttr(song: song, attr: "mediaType")+comma+getSongAttr(song: song, attr: "releaseDate")+comma+getSongAttr(song: song, attr: "isCloudItem")+comma+getSongAttr(song: song, attr: "artistPersistentID")+comma+getSongAttr(song: song, attr: "persistentID")+comma+getSongAttr(song: song, attr: "genrePersistentID"))\n")
         }
        
        return csvString
    }

    func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
   func saveToFiles(_ data: String) {
       // Where we will write our data to. This early exits if it fails to get the directory.
       guard let docDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
       else { return }
    
        let fullFilePath = docDirectoryURL.appendingPathComponent(self.fileName)
        do {
            try data.write(to: fullFilePath, atomically: true, encoding: String.Encoding.utf8)
            self.savedFileLocation = fullFilePath
        } catch {
          // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
          self.savedFileLocation = nil
        }
   }
    
    
    func export() {
        print("export")
    }
}
