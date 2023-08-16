//
//  ArchApp.swift
//  Arch
//
//  Created by Mikhail Apurin on 01.08.2023.
//

import AppContainer
import SwiftUI

@main
struct ArchApp: App {
    var body: some Scene {
        MainScene(configuration: configuration)
    }
}

let configuration = AppContainer.Configuration(
    apiBaseURL: .init(string: "https://dog.ceo/api")!
)
