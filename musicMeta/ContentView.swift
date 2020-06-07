//
//  ContentView.swift
//  musicMeta
//
//  Created by Toni Kaplan on 6/6/20.
//  Copyright © 2020 Toni Kaplan. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    var color1 = Color(red: 0.2, green: 0.2, blue: 0.2)
    var color2 = Color(red: 0.4, green: 0.4, blue: 0.4)

    
    var body: some View {
         GeometryReader { metrics in
            VStack {
                HeaderImage(image: "darkbg")
                    .frame(height: 200).clipped().edgesIgnoringSafeArea(.top)
                
                CircleImage(image: "lightbg")
                    .frame(width:200, height: 200)
                  .offset(y: -150)
                  .padding(.bottom, -150)

                VStack(alignment: .leading) {
                  Text("MetaMusic")
                      .font(.title)
                  HStack(alignment: .top) {
                      Text("Generate And Export Music Your Music App Stats")
                          .font(.subheadline)
                  }
                }
                .padding()

                
                Button(action: {
                    print("Delete tapped!")
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
