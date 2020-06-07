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
    var songData : [SongType] = []
    
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
      let myMediaQuery = MPMediaQuery.songs()
      let predicate = MPMediaPropertyPredicate(value: "I'm Just A Kid", forProperty: MPMediaItemPropertyTitle)
      myMediaQuery.addFilterPredicate(predicate)
      let items : [MPMediaItem] = myMediaQuery.items ?? []

        self.songData = items.map {
            SongType(
              title: getSongFormattedSongAttr($0.title),
              artist: getSongFormattedSongAttr($0.artist),
              albumTitle: getSongFormattedSongAttr($0.albumTitle),
              playCount:$0.playCount,
              dateAdded:$0.dateAdded,
              genre:getSongFormattedSongAttr($0.genre),
              beatsPerMinute:$0.beatsPerMinute,
              playbackDuration:$0.playbackDuration,
              skipCount:$0.skipCount,
              isExplicitItem:getSongFormattedSongAttr($0.isExplicitItem),
              releaseDate:$0.releaseDate,
              isCloudItem:getSongFormattedSongAttr($0.isCloudItem),
              artistPersistentID:getSongFormattedSongAttr($0.artistPersistentID),
              persistentID:getSongFormattedSongAttr($0.persistentID),
              genrePersistentID:getSongFormattedSongAttr($0.genrePersistentID)
            )
        }
    }
    
    func getSongFormattedSongAttr(_ attr: Any?) -> String {
        let result : String = String(describing: (attr ?? "")!)
        if(result == "\"\""){
            return "Unknown"
        }
        if(result.contains(",")){
            return "\"\(result)\""
        }
        return result
    }
    
    func formatSongData() -> String{
        var csvString = "\("Title"),\("Artist"),\("AlbumTitle"),\("PlayCount"),\("dateAdded"),\("genre"),\("beatsPerMinute"),\("playbackDuration"),\("skipCount"),\("isExplicitItem"),\("releaseDate"),\("isCloudItem"),\("artistPersistentID"),\("persistentID"),\("genrePersistentID")\n\n"
        
        let c : String = ","
        for song in self.songData {
            csvString = csvString.appending("\(song.title+c+song.artist+c+song.albumTitle+c+getSongFormattedSongAttr(song.playCount)+c+getSongFormattedSongAttr(song.dateAdded)+c+song.genre+c+getSongFormattedSongAttr(song.beatsPerMinute)+c+getSongFormattedSongAttr(song.playbackDuration)+c+getSongFormattedSongAttr(song.skipCount)+c+song.isExplicitItem+c+getSongFormattedSongAttr(song.releaseDate)+c+song.isCloudItem+c+song.artistPersistentID+c+song.persistentID+c+song.genrePersistentID)\n")
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
