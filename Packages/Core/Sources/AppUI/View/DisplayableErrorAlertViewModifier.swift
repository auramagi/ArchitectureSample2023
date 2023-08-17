//
//  DisplayableErrorAlertViewModifier.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Core
import SwiftUI

struct DisplayableErrorAlertViewModifier: ViewModifier {
    struct Dependency {
        let error: () -> AsyncStream<DisplayableError>

        let clearError: (_ id: DisplayableError.ID) -> Void
    }

    let dependency: Dependency

    @State private var error: DisplayableError?

    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: isPresented, presenting: error) { error in
                // Only the OK button
            } message: { error in
                Text(error.message)
            }
            .onChange(of: error?.id) { [oldValue = error?.id] newValue in
                if let oldValue {
                    dependency.clearError(oldValue)
                }
            }
            .task {
                for await error in dependency.error() {
                    self.error = error
                }
            }

    }

    var isPresented: Binding<Bool> {
        .init(
            get: { error != nil },
            set: { _ in error = nil }
        )
    }
}
