//
//  UserScreen.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Core
import SwiftUI

struct UserScreen<ViewData: UserSettingsViewData>: View {
    let userSettings: ViewData

    var body: some View {
        Button("Show Welcome Screen") {
            userSettings.handle(.setDidShowWelcome(false))
        }
        .buttonStyle(.borderedProminent)
        .modifier(userSettings)
    }
}

struct UserScreen_Previews: PreviewProvider {
    static let container = PreviewContainer()

    static var previews: some View {
        UserFlow(container: container)
    }
}
