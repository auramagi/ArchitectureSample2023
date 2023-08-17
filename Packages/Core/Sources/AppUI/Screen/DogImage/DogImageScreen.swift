//
//  DogImageScreen.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Core
import SwiftUI

struct DogImageScreen: View {
    struct Dependency {
        let getDogImage: () async -> URL?
    }

    let dependency: Dependency

    @State private var url: LoadingState<URL> = .notStarted

    @State private var id = UUID()

    @State private var loadedID = UUID()

    var body: some View {
        VStack {
            Group {
                switch url.result {
                case let .success(url):
                    DogImage(url: url)

                case .failure:
                    TaskFailedView()

                case .none:
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button {
                id = .init()
            } label: {
                Label("Reload", systemImage: "arrow.triangle.2.circlepath")
            }
            .buttonStyle(.borderedProminent)
            .disabled(!url.isLoaded)
            .padding()

        }
        .task(id: id) {
            guard loadedID != id else { return } // Load only once unless reloading by button
            loadedID = id
            url = .loading
            if let result = await dependency.getDogImage() {
                url = .loaded(.success(result))
            } else {
                url = .loaded(.failure(.message("Couldn't get image URL.")))
            }
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
                TaskFailedView()

            @unknown default:
                ProgressView()
            }
        }
    }
}

struct DogImageScreen_Previews: PreviewProvider {
    static let container = PreviewContainer()

    static var previews: some View {
        DogImageScreen(dependency: .init(
            getDogImage: container.makeRandomDogImageService().getRandomDogImage
        ))
    }
}
