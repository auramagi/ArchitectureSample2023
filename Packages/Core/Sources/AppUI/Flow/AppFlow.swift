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

    @State var didShowWelcome = false

    public init(container: Container) {
        self.container = container
    }
    
    public var body: some View {
        ZStack {
            if didShowWelcome {
                mainTabDestination
            } else {
                welcomeDestination
            }
        }
        .animation(.default, value: didShowWelcome)
        .modifier(DisplayableErrorAlertViewModifier(dependency: .init(error: { container.displayableErrorRepository.error }, clearError: container.displayableErrorRepository.clearError(id:))))
    }

    @ViewBuilder var mainTabDestination: some View {
        MainTabFlow(container: container)
    }

    @ViewBuilder var welcomeDestination: some View {
        WelcomeFlow(container: container) { action in
            switch action {
            case .dismiss:
                didShowWelcome = true
            }
        }
    }
}

struct AppFlow_Previews: PreviewProvider {
    static let container = PreviewContainer()

    static var previews: some View {
        AppFlow(container: container)
    }
}
