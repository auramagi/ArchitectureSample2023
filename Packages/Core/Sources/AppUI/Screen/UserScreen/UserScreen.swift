//
//  UserScreen.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Core
import SwiftUI

struct UserScreen<UserSettings: UserSettingsRepository>: View {
    let userSettings: UserSettings

    var body: some View {
        WithViewData(userSettings) { userSettings in
            Button("Show Welcome Screen") {
                userSettings.handle(.setDidShowWelcome(false))
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct UserScreen_Previews: PreviewProvider {
    static let container = PreviewContainer()

    static var previews: some View {
        UserFlow(container: container)
    }
}
