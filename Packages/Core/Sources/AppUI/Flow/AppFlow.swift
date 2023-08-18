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

    public init(container: Container) {
        self.container = container
    }
    
    public var body: some View {
        WithViewData(container.userSettingsRepository) { userSettings in
            ZStack {
                if userSettings.entity.didShowWelcome {
                    mainTabDestination
                } else {
                    welcomeDestination
                }
            }
            .animation(.default, value: userSettings.entity.didShowWelcome)
        }
        .modifier(DisplayableErrorAlertViewModifier(dependency: .init(error: { container.displayableErrorRepository.error }, clearError: container.displayableErrorRepository.clearError(id:))))
    }

    @ViewBuilder var mainTabDestination: some View {
        MainTabFlow(container: container)
    }

    @ViewBuilder var welcomeDestination: some View {
        WelcomeFlow(container: container)
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
