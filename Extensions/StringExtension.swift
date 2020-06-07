//
//  StringExtension.swift
//  musicMeta
//
//  Created by Toni Kaplan on 6/7/20.
//  Copyright © 2020 Toni Kaplan. All rights reserved.
//

import Foundation

extension String {
    func getWithCapitalizedFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
