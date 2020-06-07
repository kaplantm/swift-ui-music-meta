//
//  HeaderImage.swift
//  musicMeta
//
//  Created by Toni Kaplan on 6/6/20.
//  Copyright © 2020 Toni Kaplan. All rights reserved.
//

import SwiftUI

struct HeaderImage: View {
    var image = "main"
    
    var body: some View {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .shadow(radius: 10)
    }
}

struct HeaderImage_Previews: PreviewProvider {
    static var previews: some View {
        HeaderImage().frame(width: 200, height: 200)
    }
}
