//
//  UserSettingsRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

public protocol UserSettingsRepository: ViewDataRepository<Void, UserSettings, UserSettingsViewDataAction> { }

public enum UserSettingsViewDataAction {
    case setDidShowWelcome(Bool)
}
