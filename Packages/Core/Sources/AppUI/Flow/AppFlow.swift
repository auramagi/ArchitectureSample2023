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
        NavigationStack {
            List {
                NavigationLink("Dogs", destination: dogs)

                NavigationLink("Tags", destination: tags)
            }
            .navigationTitle("Top")
        }
    }

    @ViewBuilder var dogs: some View {
        let service = DogService(dependency: .init(getRandomDog: container.dogRepository.getRandomDog, sendError: container.displayableErrorRepository.sendError(_:)))
        DogScreen(dependency: .init(getRandomDog: service.getRandomDog))
            .navigationTitle("Dogs")
    }

    @ViewBuilder var tags: some View {
        let repo = container.tagRepository
        repo.build { collection in
            List {
                collection.forEach { value in
                    VStack(alignment: .leading) {
                        Text(value.element.name)

                        Button("Delete", role: .destructive) {
                            value.handle(.delete)
                        }
                    }
                }
                .onDelete { offsets in
                    collection.handle(.delete(offsets: offsets))
                }

            }
            .toolbar {
                ToolbarItem {
                    Button {
                        let tag = Tag(name: UUID().uuidString)
                        collection.handle(.add(tag: tag))
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Tag list")
        }
    }
}

struct DogScreen: View {
    struct Dependency {
        let getRandomDog: () async -> URL?
    }

    let dependency: Dependency

    @State private var url: URL?

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
                Color.gray

            @unknown default:
                ProgressView()
            }
        }
        .task {
            self.url = await dependency.getRandomDog()
        }
    }
}

struct AppFlow_Previews: PreviewProvider {
    static let container = PreviewContainer()
    static var previews: some View {
        AppFlow(container: container)
    }
}
