//
//  UserSettingsViewData.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import SwiftUI

public enum UserSettingsViewDataAction {
    case setDidShowWelcome(Bool)
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

public struct MockUserSettingsViewData: ViewData {
    @State var userSettings: UserSettings

    init(initialValue: UserSettings) {
        self._userSettings = .init(initialValue: initialValue)
    }

    public var entity: UserSettings { userSettings }

    public func handle(_ action: UserSettingsViewDataAction) -> Task<Void, Never>? {
        switch action {
        case let .setDidShowWelcome(newValue):
            userSettings.didShowWelcome = newValue
        }
        return nil
    }
}
