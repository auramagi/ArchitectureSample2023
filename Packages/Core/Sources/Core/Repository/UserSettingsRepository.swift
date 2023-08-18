//
//  UserSettingsRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import SwiftUI

public protocol UserSettingsRepository: ViewDataRepository<Void, UserSettings, UserSettingsViewDataAction> {
}

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

public struct UserDefaultsViewModifier: ViewModifier {
    let userDefaults: UserDefaults

    public func body(content: Content) -> some View {
        content
            .defaultAppStorage(userDefaults)
    }
}

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
