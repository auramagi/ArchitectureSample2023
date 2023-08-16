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
        TabView {
            dogs
                .tabItem {
                    Label("Random", systemImage: "photo")
                }
        }
        .modifier(DisplayableErrorAlertViewModifier(dependency: .init(error: { container.displayableErrorRepository.error }, clearError: container.displayableErrorRepository.clearError(id:))))
    }

    @ViewBuilder var dogs: some View {
        let service = DogService(dependency: .init(getRandomDog: container.dogRepository.getRandomDog, sendError: container.displayableErrorRepository.sendError(_:)))
        DogScreen(dependency: .init(getRandomDog: service.getRandomDog))
    }
}

struct DogScreen: View {
    struct Dependency {
        let getRandomDog: () async -> URL?
    }

    let dependency: Dependency

    @State private var url: URL?

    @State private var id = UUID()

    @State private var isLoading = false

    var body: some View {
        VStack {
            Group {
                if isLoading {
                    ProgressView()
                } else if let url {
                    DogImage(url: url)
                } else {
                    ImageFailureView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button {
                id = .init()
            } label: {
                Label("Reload", systemImage: "arrow.triangle.2.circlepath")
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)
            .padding()

        }
        .task(id: id) {
            isLoading = true
            url = await dependency.getRandomDog()
            isLoading = false
        }
    }
}

struct DogImage: View {
    let url: URL

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()

            case let .success(image):
                image
                    .resizable()
                    .scaledToFit()

            case .failure:
                ImageFailureView()

            @unknown default:
                ProgressView()
            }
        }
    }
}

struct ImageFailureView: View {
    var body: some View {
        Image(systemName: "xmark")
            .symbolRenderingMode(.multicolor)
            .imageScale(.large)
    }
}

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

struct AppFlow_Previews: PreviewProvider {
    static let container = PreviewContainer()

    static var previews: some View {
        AppFlow(container: container)
    }
}
