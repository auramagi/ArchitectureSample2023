//
//  UserSettingsViewData.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import SwiftUI

public typealias UserSettingsViewData = ViewData<UserSettings, UserSettingsViewDataAction>

public enum UserSettingsViewDataAction {
    case setDidShowWelcome(Bool)
}

struct CoreUserSettingsViewData: ViewData {
    @AppStorage("DidShowWelcome") var didShowWelcome = false

    var element: UserSettings {
        .init(
            didShowWelcome: didShowWelcome
        )
    }

    func handle(_ action: UserSettingsViewDataAction) -> Task<Void, Never>? {
        switch action {
        case let .setDidShowWelcome(newValue):
            didShowWelcome = newValue
        }
        return nil
    }
}

struct MockUserSettingsViewData: ViewData {
    @State var userSettings: UserSettings

    init(initialValue: UserSettings) {
        self._userSettings = .init(initialValue: initialValue)
    }

    var element: UserSettings { userSettings }

    func handle(_ action: UserSettingsViewDataAction) -> Task<Void, Never>? {
        switch action {
        case let .setDidShowWelcome(newValue):
            userSettings.didShowWelcome = newValue
        }
        return nil
    }
}
