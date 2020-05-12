//
//  MadogToken.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

struct MadogToken {
    let identifier: String
    let components: [String]

    init(identifier: String, components: [String] = []) {
        self.identifier = identifier
        self.components = components
    }
}
