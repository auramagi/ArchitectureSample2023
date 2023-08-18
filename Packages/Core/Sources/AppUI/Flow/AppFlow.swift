//
//  AppFlow.swift
//  
//
//  Created by Mikhail Apurin on 01.08.2023.
//

import Core
import SwiftUI

public struct AppFlow<Container: AppUIContainer>: View {
    let container: Container

    let userSettings: Container.UserSettingsRepositoryType.ViewDataType

    public init(container: Container) {
        self.container = container
        self.userSettings = container.userSettingsRepository.makeData()
    }
    
    public var body: some View {
        ZStack {
            if userSettings.entity.didShowWelcome {
                mainTabDestination
            } else {
                welcomeDestination
            }
        }
        .animation(.default, value: userSettings.entity.didShowWelcome)
        .modifier(userSettings)
        .modifier(DisplayableErrorAlertViewModifier(dependency: .init(error: { container.displayableErrorRepository.error }, clearError: container.displayableErrorRepository.clearError(id:))))
    }

    @ViewBuilder var mainTabDestination: some View {
        MainTabFlow(container: container)
    }

    @ViewBuilder var welcomeDestination: some View {
        WelcomeFlow(container: container) { action in
            switch action {
            case .dismiss:
                _ = userSettings.handle(.setDidShowWelcome(true))
            }
        }
    }
}

struct AppFlow_Previews: PreviewProvider {
    static var previews: some View {
        AppFlow(container: .preview())
            .previewDisplayName("Initial")

        AppFlow(container: .preview(.default.with(\.didShowWelcome, true)))
            .previewDisplayName("After dismissing Welcome")
    }
}
