//
//  MusicMeta.swift
//  musicMeta
//
//  Created by Toni Kaplan on 6/7/20.
//  Copyright © 2020 Toni Kaplan. All rights reserved.
//

import Foundation
import MediaPlayer
import SwiftUI

struct MusicMeta {
    private let fileName = "musicMeta.csv"    
    let fileManager = FileManager.default
    var fileLocation : URL? {
// Where we will write our data to. This early exits if it fails to get the directory.
           guard let docDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
           else { return nil}
           return docDirectoryURL.appendingPathComponent(fileName)
    }
    static var isMusicAuthorized : Bool {
        return MPMediaLibrary.authorizationStatus() == .authorized
    };
    
    static func requestMusicAuth(_ callback: @escaping (_ status:Bool)->()) {
        let status : MPMediaLibraryAuthorizationStatus = MPMediaLibrary.authorizationStatus()
       
       if(status == .notDetermined){
        MPMediaLibrary.requestAuthorization() { newStatus in
            callback(newStatus == .authorized)
           }
       }
       else{
        if(status != .authorized){
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        callback(status == .authorized)
       }
    }
    
     static func generateStats(songData:[SongItem]) -> [String:String]{
        var dict : [String:String] = [
            "mostPlayed": "Unknown",
            "mostSkipped": "Unknown",
            "longest": "Unknown",
            "shortest": "Unknown",
            "oldest": "Unknown",
            "newest": "Unknown",
            "recentlyAdded": "Unknown",
            "leastRecentlyAdded": "Unknown",
        ]
        let arrayLength = songData.count
        if(arrayLength < 1){
            return dict
        }
    
        if(arrayLength == 1){
            let song = songData[0].stringDict
            dict = [
                "mostPlayed": song["playCount"]!,
                "mostSkipped":song["skipCount"]!,
                "longest": song["playbackDuration"]!,
                "shortest": song["playbackDuration"]!,
                "oldest": song["releaseDate"]!,
                "newest": song["releaseDate"]!,
                "recentlyAdded": song["dateAdded"]!,
                "leastRecentlyAdded": song["dateAdded"]!
            ]
            return dict
        }
        
        var sortedArrayCopy = songData.sorted(by: { $0.playCount > $1.playCount })
        dict["mostPlayed"] = sortedArrayCopy[0].stringDict["playCount"]! + " Plays - " + sortedArrayCopy[0].stringDict["title"]!
        
        sortedArrayCopy = songData.sorted(by: { $0.skipCount > $1.skipCount })
        dict["mostSkipped"] = sortedArrayCopy[0].stringDict["skipCount"]! + " Skips - " + sortedArrayCopy[0].stringDict["title"]!
 
        sortedArrayCopy = songData.sorted(by: { $0.playbackDuration > $1.playbackDuration })
        dict["longest"] = sortedArrayCopy[0].stringDict["playbackDuration"]! + " Seconds - " + sortedArrayCopy[0].stringDict["title"]!
        dict["shortest"] = sortedArrayCopy[arrayLength-1].stringDict["playbackDuration"]! + " Seconds - " + sortedArrayCopy[arrayLength-1].stringDict["title"]!

        let dateArray : [Date] = songData.compactMap({ song in
            song.releaseDate
        }).sorted(by: { $0 > $1 })
        dict["newest"] = "Released "+SongItem.dateToString(dateArray.first) + " - " + sortedArrayCopy[0].stringDict["title"]!
        dict["oldest"] = "Released "+SongItem.dateToString(dateArray[dateArray.count-1]) + " - " + sortedArrayCopy[dateArray.count-1].stringDict["title"]!

        sortedArrayCopy = songData.sorted(by: { $0.dateAdded > $1.dateAdded })
        dict["leastRecentlyAdded"] = "Added "+sortedArrayCopy[0].stringDict["dateAdded"]! + " - " + sortedArrayCopy[0].stringDict["title"]!
        dict["recentlyAdded"] = "Added "+sortedArrayCopy[arrayLength-1].stringDict["dateAdded"]! + " - " + sortedArrayCopy[arrayLength-1].stringDict["title"]!
        
        return dict
    }
    
    func generateSongData() -> [SongItem] {
      let myMediaQuery = MPMediaQuery.songs()
//      let predicate = MPMediaPropertyPredicate(value: "Green Day", forProperty: MPMediaItemPropertyArtist)
//      myMediaQuery.addFilterPredicate(predicate)
      let items : [MPMediaItem] = myMediaQuery.items ?? []

        return items.map { entity in
            SongItem(song: entity)
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
        return array.reduce("") {
            (accumulation: String, nextValue: String) -> String in
            return accumulation + formatStringForCSV(value: nextValue) + ","
        }
     }
 
    func formatSongData(songData:[SongItem]) -> String {
        let fields = SongItem.fields;
        var csvString = fields.reduce("") {
            (accumulation: String, nextValue: String) -> String in
            return accumulation + nextValue.getWithCapitalizedFirstLetter() + ","
        }
        csvString.append("\n\n")

        for songClass in songData {
            print("in songData iterable", songData.count)
            let songFieldArray : [String] = songClass.asFieldsArray(fields: fields);
            csvString = csvString.appending("\(formatStringArrayForCSV(array: songFieldArray))\n")
         }
        
        return csvString
    }

    func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
   func saveToFiles(_ data: String) -> Bool {
        if(fileLocation != nil){
            do {
                try data.write(to: fileLocation!, atomically: true, encoding: String.Encoding.utf8)
                return true;
            } catch {
              // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                return false
            }
        }
        return false
   }
}
