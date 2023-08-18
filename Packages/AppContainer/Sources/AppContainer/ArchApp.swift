//
//  AppSupport.swift
//
//
//  Created by Mikhail Apurin on 01.08.2023.
//

import AppUI
import Core
import DogAPI
import RealmSwift
import RealmStorage
import SwiftUI

public struct MainScene: Scene {
    @State var container: LiveAppContainer
//    @State var container = PreviewContainer()

    public init(configuration: AppContainer.Configuration) {
        self.container = .init(configuration: configuration)
    }
    
    public var body: some Scene {
        WindowGroup {
            AppFlow(container: container)
        }
    }
}

public enum AppContainer {
    public struct Configuration {
        let apiBaseURL: URL

        public init(
            apiBaseURL: URL
        ) {
            self.apiBaseURL = apiBaseURL
        }
    }
}

final class LiveAppContainer: AppUIContainer {
    let displayableErrorRepository: some DisplayableErrorRepository = CoreDisplayableErrorRepository(errors: [])

    let dogRepository: APIDogRepository

    let dogBreedRepository: CoreDogBreedRepository

    let userSettingsRepository: CoreUserSettingsRepository

    init(configuration: AppContainer.Configuration) {
        let api = APIClient(session: .shared, configuration: .init(baseURL: configuration.apiBaseURL))
        let userDefaults = UserDefaults.standard
        let configuration = Realm.Configuration.defaultConfiguration
        self.dogRepository = api
        self.dogBreedRepository = .init(getBreedList: api.getBreedList)
        self.userSettingsRepository = .init(userDefaults: userDefaults)
    }
}
