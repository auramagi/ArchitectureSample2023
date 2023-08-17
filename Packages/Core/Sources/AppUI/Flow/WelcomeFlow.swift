//
//  WelcomeFlow.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Core
import SwiftUI

struct WelcomeFlow<Container: AppUIContainer>: View {
    enum Action {
        case dismiss
    }

    let container: Container

    let actionHandler: (Action) -> Void

    var body: some View {
        VStack(spacing: 64) {
            Text("Welcome")
                .font(.largeTitle.bold())

            Text("Thank you for installing this app!")

            Button("Show me dogs") {
                actionHandler(.dismiss)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct WelcomeFlow_Previews: PreviewProvider {
    static let container = PreviewContainer()

    static var previews: some View {
        WelcomeFlow(container: container, actionHandler: { _ in })
    }
}
