//
//  AppSupport.swift
//
//
//  Created by Mikhail Apurin on 01.08.2023.
//

import AppUI
import SwiftUI

public struct ArchApp: App {
    public init() { }
    
    public var body: some Scene {
        WindowGroup {
            AppFlow()
        }
    }
}
