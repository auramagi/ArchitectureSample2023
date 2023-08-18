//
//  CoreUserSettingsRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/18.
//

import SwiftUI

public final class CoreUserSettingsRepository: UserSettingsRepository {
    let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func makeData(object: Void) -> CoreUserSettingsViewData {
        .init()
    }

    public var dataEnvironment: UserDefaultsViewModifier {
        .init(userDefaults: userDefaults)
    }
}

public struct CoreUserSettingsViewData: ViewData {
    @AppStorage("DidShowWelcome") var didShowWelcome = false

    public var entity: UserSettings {
        .init(
            didShowWelcome: didShowWelcome
        )
    }

    public func handle(_ action: UserSettingsViewDataAction) -> Task<Void, Never>? {
        switch action {
        case let .setDidShowWelcome(newValue):
            didShowWelcome = newValue
        }
        return nil
    }
}

public struct UserDefaultsViewModifier: ViewModifier {
    let userDefaults: UserDefaults

    public func body(content: Content) -> some View {
        content
            .defaultAppStorage(userDefaults)
    }
}
