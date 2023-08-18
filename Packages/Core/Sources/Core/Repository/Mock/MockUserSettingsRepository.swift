//
//  MockUserSettingsRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/18.
//

import SwiftUI

public final class MockUserSettingsRepository: UserSettingsRepository {
    let _viewData: MockUserSettingsViewData

    public init(initialValue: UserSettings) {
        self._viewData = .init(initialValue: initialValue)
    }

    public func makeData(object: Void) -> MockUserSettingsViewData {
        _viewData
    }
}

public extension UserSettingsRepository where Self == MockUserSettingsRepository {
    static func mock(initialValue: UserSettings = .mock) -> Self {
        .init(initialValue: initialValue)
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
