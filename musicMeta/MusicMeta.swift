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
    var songData : [SongItem] = []
    
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
//      let predicate = MPMediaPropertyPredicate(value: "Green Day", forProperty: MPMediaItemPropertyArtist)
//      myMediaQuery.addFilterPredicate(predicate)
      let items : [MPMediaItem] = myMediaQuery.items ?? []

        self.songData = items.map { entity in
            return SongItem(song: entity)
        }
    }
    
    func formatStringForCSV(value: String) -> String {
          if(value == "\"\""){
              return "Unknown"
          }
          if(value.contains(",")){
              return "\"\(value)\""
          }
          return value
      }
    
    func formatStringArrayForCSV(array: [String]) -> String {
        print("formatStringDictForCSV")
        print(array)
        return array.reduce("") {
            (accumulation: String, nextValue: String) -> String in
            return accumulation + formatStringForCSV(value: nextValue) + ","
        }
     }
 
    func formatSongData() -> String {
        let fields : [String] = ["title","artist","albumTitle","playCount","dateAdded","genre","beatsPerMinute","playbackDuration","skipCount","isExplicitItem","releaseDate", "isCloudItem","artistPersistentID","persistentID","genrePersistentID"]
        var csvString = fields.reduce("") {
            (accumulation: String, nextValue: String) -> String in
            return accumulation + nextValue.getWithCapitalizedFirstLetter() + ","
        }
        csvString.append("\n\n")

        for songClass in self.songData {
            print("in songData iterable", self.songData.count)
            let songFieldArray : [String] = songClass.asFieldsArray(fields: fields);
            csvString = csvString.appending("\(formatStringArrayForCSV(array: songFieldArray))\n")
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
