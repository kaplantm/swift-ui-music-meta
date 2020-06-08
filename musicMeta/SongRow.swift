//
//  SongRow.swift
//  musicMeta
//
//  Created by Toni Kaplan on 6/7/20.
//  Copyright © 2020 Toni Kaplan. All rights reserved.
//

import SwiftUI
import MediaPlayer

struct SongRow: View {
    let SongAsFieldsArray: [String]
    
    var body: some View {
        HStack {
            
            ForEach(0 ..< SongAsFieldsArray.count) { number in
                Text(self.SongAsFieldsArray[number])
               }
            
//            SongAsFieldsArray.map(<#T##transform: (String) throws -> T##(String) throws -> T#>)
//                  landmark.image
//                      .resizable()
//                      .frame(width: 50, height: 50)
//            Text(song.title)
//                  Text(song.artist ?? "")
//                  Text(song.albumTitle ?? "")
//                  Text(String(song.playCount))
//                  Text(song.albumTitle  ?? "")
//                  Text(song.dateAdded ?? "")
//                  Text(song.genre ?? "")
//                  Text(String(song.beatsPerMinute))
//                  Text(String(song.playbackDuration))
//                  Text(String(song.isExplicitItem))
//                  Text(song.releaseDate)
//                  Text(String(song.isCloudItem))
//                  Text(String(song.artistPersistentID))
//                  Text(song.genrePersistentID)
//                  Text(song.albumTitle != "" ? song.albumTitle : "Unknown" )
//                  Spacer()
              }
    }
}

struct SongRow_Previews: PreviewProvider {
    static var previews: some View {
        SongRow(SongAsFieldsArray: ["title","artist","albumTitle","playCount","dateAdded","genre","beatsPerMinute","playbackDuration","skipCount","isExplicitItem","releaseDate", "isCloudItem","artistPersistentID","persistentID","genrePersistentID"])
    }
}
