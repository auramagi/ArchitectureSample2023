//
//  UserSettingsRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

public protocol UserSettingsRepository: ViewDataRepository<Void, UserSettings, UserSettingsViewDataAction> {
}

public final class CoreUserSettingsRepository: UserSettingsRepository {
    public init() { }

    public func makeData(object: Void) -> CoreUserSettingsViewData {
        .init()
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
