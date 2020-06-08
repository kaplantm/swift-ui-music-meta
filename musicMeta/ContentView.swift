//
//  ContentView.swift
//  musicMeta
//
//  Created by Toni Kaplan on 6/6/20.
//  Copyright © 2020 Toni Kaplan. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @State private var isShareSheetShowing = false
    var color1 = Color(red: 0.2, green: 0.2, blue: 0.2)
    var color2 = Color(red: 0.4, green: 0.4, blue: 0.4)
//    @State var musicMeta = MusicMeta()
    @State private var songData : [SongItem] = []
    @State private var musicMeta = MusicMeta()
    @State private var isMusicAuthorized : Bool = MusicMeta.isMusicAuthorized
    @State private var songStats : [String:String] = MusicMeta.generateStats(songData: [])


    func onClickShareButton(){
        let data = musicMeta.formatSongData(songData:songData)
        let hasFile = musicMeta.saveToFiles(data)
        
        if(hasFile){
            isShareSheetShowing.toggle();
            let activityView = UIActivityViewController(activityItems: [musicMeta.fileLocation!], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityView, animated: true, completion:nil)
        }
    }
    
    func onMusicAuthRequestComplete(isMusicAuthorized:Bool){
        self.isMusicAuthorized = isMusicAuthorized
    }
    
    var body: some View {
         GeometryReader { geometry in
            VStack {
                HeaderImage(image: "darkbg")
                    .frame(height: 200).clipped().edgesIgnoringSafeArea(.top)
                
                CircleImage(image: "lightbg")
                    .frame(width:200, height: 200)
                  .offset(y: -200)
                  .padding(.bottom, -200)

                VStack(alignment: .leading) {
                    Text("MusicMeta")
                      .font(.title)
                  HStack(alignment: .top) {
                      Text("Generate And Export Music Your Music App Stats")
                          .font(.subheadline)
                  }
                }
                .padding()

                
                if(self.isMusicAuthorized == false){
                    Button(action: {
                        MusicMeta.requestMusicAuth(self.onMusicAuthRequestComplete)
                    }) {
                        HStack {
                            Image(systemName: "music.house")
                                .font(.title)
                            Text("Allow Access To Music Library")
                                .fontWeight(.semibold)
                                .font(.callout)
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [self.color1, self.color2]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                    }
                }
                else{
                
                Button(action: {
                    self.songData = self.musicMeta.generateSongData()
                    self.songStats = MusicMeta.generateStats(songData: self.songData)
                }) {
                    HStack {
                        Image(systemName: "music.note.list")
                            .font(.title)
                        Text("Generate Music Meta")
                            .fontWeight(.semibold)
                            .font(.callout)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [self.color1, self.color2]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                }
                
                    
                    if(self.songData.count > 0){
                        ScrollView {
                            VStack(spacing: 20) {
                                VStack() {
                                     HStack {
                                        Image(systemName: "music.note.list")
                                            .font(.title)
                                        Text("Most Played:")
                                            .fontWeight(.semibold)
                                            .font(.callout)
                                        }
                                    Text(self.songStats["mostPlayed"]!)
                                       .fontWeight(.semibold)
                                       .font(.callout)
                                }
                                VStack() {
                                    HStack {
                                      Image(systemName: "music.note.list")
                                          .font(.title)
                                      Text("Most Skipped: ")
                                          .fontWeight(.semibold)
                                          .font(.callout)
                                    }
                                    Text(self.songStats["mostSkipped"]!)
                                       .fontWeight(.semibold)
                                       .font(.callout)
                                }
                                VStack() {
                                    HStack {
                                       Image(systemName: "music.note.list")
                                           .font(.title)
                                       Text("Longest: ")
                                           .fontWeight(.semibold)
                                           .font(.callout)
                                    }
                                    Text(self.songStats["longest"]!)
                                       .fontWeight(.semibold)
                                       .font(.callout)
                                }
                                VStack() {
                                    HStack {
                                    Image(systemName: "music.note.list")
                                        .font(.title)
                                    Text("Shortest: ")
                                        .fontWeight(.semibold)
                                        .font(.callout)
                                      }
                                    Text(self.songStats["shortest"]!)
                                      .fontWeight(.semibold)
                                      .font(.callout)
                                }
                                VStack() {
                                    HStack {
                                       Image(systemName: "music.note.list")
                                           .font(.title)
                                       Text("Oldest Release: ")
                                           .fontWeight(.semibold)
                                           .font(.callout)
                                                       }
                                       Text(self.songStats["oldest"]!)
                                          .fontWeight(.semibold)
                                          .font(.callout)
                                }
                                VStack() {
                                    HStack {
                                    Image(systemName: "music.note.list")
                                        .font(.title)
                                    Text("Newest Release: ")
                                        .fontWeight(.semibold)
                                        .font(.callout)
                                     }
                                     Text(self.songStats["newest"]!)
                                        .fontWeight(.semibold)
                                        .font(.callout)
                                }
                                VStack() {
                                    HStack {
                                      Image(systemName: "music.note.list")
                                          .font(.title)
                                      Text("Newly Added: ")
                                          .fontWeight(.semibold)
                                          .font(.callout)
                                  }
                                  Text(self.songStats["recentlyAdded"]!)
                                     .fontWeight(.semibold)
                                     .font(.callout)
                                }
                                VStack() {
                                    HStack {
                                       Image(systemName: "music.note.list")
                                           .font(.title)
                                       Text("Earliest Added: ")
                                           .fontWeight(.semibold)
                                           .font(.callout)
                                        }
                                    Text(self.songStats["leastRecentlyAdded"]!)
                                       .fontWeight(.semibold)
                                       .font(.callout)
                                }
                            }
                        }
                    Button(action: {
                        self.onClickShareButton()
                     }) {
                         HStack {
                             Image(systemName: "square.and.arrow.down")
                                 .font(.title)
                             Text("Save as csv")
                                 .fontWeight(.semibold)
                                 .font(.callout)
                         }
                         .padding()
                         .foregroundColor(.white)
                         .background(LinearGradient(gradient: Gradient(colors: [self.color1, self.color2]), startPoint: .leading, endPoint: .trailing))
                         .cornerRadius(40)
                     }

                }
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
