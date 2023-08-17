//
//  UserSettingsRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

public protocol UserSettingsRepositoryProtocol {
    associatedtype ViewData: UserSettingsViewData

    func viewData() -> ViewData
}

public final class CoreUserSettingsRepository: UserSettingsRepositoryProtocol {
    public init() { }

    public func viewData() -> some UserSettingsViewData {
        CoreUserSettingsViewData()
    }
}

public final class MockUserSettingsRepository: UserSettingsRepositoryProtocol {
    let _viewData: MockUserSettingsViewData

    public init(initialValue: UserSettings) {
        self._viewData = .init(initialValue: initialValue)
    }

    public func viewData() -> some UserSettingsViewData {
        _viewData
    }
}
