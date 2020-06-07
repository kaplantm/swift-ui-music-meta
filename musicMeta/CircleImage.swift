//
//  CircleImage.swift
//  musicMeta
//
//  Created by Toni Kaplan on 6/6/20.
//  Copyright © 2020 Toni Kaplan. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var image = "main"
    
    var body: some View {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage().frame(width: 200, height: 200)
    }
}
