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
        let data = userSettings.makeData()

        Button("Show Welcome Screen") {
            data.handle(.setDidShowWelcome(false))
        }
        .buttonStyle(.borderedProminent)
        .modifier(data)
        .modifier(userSettings.dataEnvironment)
    }
}

struct UserScreen_Previews: PreviewProvider {
    static let container = PreviewContainer()

    static var previews: some View {
        UserFlow(container: container)
    }
}
