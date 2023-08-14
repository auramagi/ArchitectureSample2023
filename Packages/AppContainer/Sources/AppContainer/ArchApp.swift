//
//  AppSupport.swift
//
//
//  Created by Mikhail Apurin on 01.08.2023.
//

import AppUI
import RealmStorage
import SwiftUI

public struct MainScene: Scene {
    @State var container = LiveAppContainer()
//    @State var container = PreviewContainer()

    public init() {
        
    }
    
    public var body: some Scene {
        WindowGroup {
            AppFlow(container: container)
        }
    }
}

final class LiveAppContainer: AppContainer {
    var tagRepository: RealmResolver {
        RealmResolver()
    }
}
