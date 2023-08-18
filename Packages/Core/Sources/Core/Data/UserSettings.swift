//
//  File.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

public struct UserSettings {
    public var didShowWelcome: Bool

    public init(didShowWelcome: Bool) {
        self.didShowWelcome = didShowWelcome
    }
}

extension UserSettings {
    public static var mock: Self {
        .init(didShowWelcome: false)
    }
}
