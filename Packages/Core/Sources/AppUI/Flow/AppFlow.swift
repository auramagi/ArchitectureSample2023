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
        MainTabFlow(container: container)
            .modifier(DisplayableErrorAlertViewModifier(dependency: .init(error: { container.displayableErrorRepository.error }, clearError: container.displayableErrorRepository.clearError(id:))))
    }
}

struct AppFlow_Previews: PreviewProvider {
    static let container = PreviewContainer()

    static var previews: some View {
        AppFlow(container: container)
    }
}
