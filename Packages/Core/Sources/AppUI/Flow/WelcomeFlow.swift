//
//  WelcomeFlow.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Core
import SwiftUI

struct WelcomeFlow<Container: AppUIContainer>: View {
    let container: Container

    var body: some View {
        WithViewData(container.userSettingsRepository) { userSettings in
            VStack(spacing: 64) {
                Text("Welcome")
                    .font(.largeTitle.bold())

                Text("Thank you for installing this app!")

                Button("Show me dogs") {
                    userSettings.handle(.setDidShowWelcome(true))
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct WelcomeFlow_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeFlow(container: .preview())
    }
}
