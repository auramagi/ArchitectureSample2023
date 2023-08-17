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
            randomImageDestination
                .tabItem {
                    Label("Random", systemImage: "photo")
                }

            breedListDestination
                .tabItem {
                    Label("Breeds", systemImage: "list.bullet")
                }
        }
        .modifier(DisplayableErrorAlertViewModifier(dependency: .init(error: { container.displayableErrorRepository.error }, clearError: container.displayableErrorRepository.clearError(id:))))
    }

    @ViewBuilder var randomImageDestination: some View {
        let service = RandomDogImageService(dependency: .init(getRandomDogImage: container.dogRepository.getRandomDogImage, sendError: container.displayableErrorRepository.sendError(_:)))

        NavigationStack {
            DogScreen(dependency: .init(getDogImage: service.getRandomDogImage))
                .navigationTitle("Random Dog")
        }
    }

    @ViewBuilder var breedListDestination: some View {
        NavigationStack {
            BreedListScreen(dependency: .init(
                getBreedList: container.dogRepository.getBreedList
            ))
            .navigationTitle("Breeds")
            .navigationDestination(for: BreedListScreen.Destination.self) { destination in
                switch destination {
                case let .breedImage(breed):
                    breedImageDestination(breed: breed)
                }
            }
        }
    }

    @ViewBuilder func breedImageDestination(breed: ConcreteBreed) -> some View {
        let service = DogBreedImageService(dependency: .init(
            getDogBreedImage: container.dogRepository.getDogBreedImage(breed:),
            getDogSubBreedImage: container.dogRepository.getDogSubBreedImage(breed:subBreed:),
            sendError: container.displayableErrorRepository.sendError(_:)
        ))

        DogScreen(dependency: .init(getDogImage: { await service.getDogBreedImage(breed: breed) }))
            .navigationTitle(breed.formatted(.breedName))
    }
}


struct DogScreen: View {
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

struct BreedListScreen: View {
    struct Dependency {
        let getBreedList: () async throws -> BreedList
    }

    enum Destination: Hashable {
        case breedImage(breed: ConcreteBreed)
    }

    let dependency: Dependency

    @State private var breeds: LoadingState<[BreedListItem]> = .notStarted

    @State private var id = UUID()

    @State private var loadedID = UUID()

    var body: some View {
        ZStack {
            switch breeds.result {
            case let .success(breeds):
                List {
                    Section {
                        ForEach(breeds, id: \.self) { item in
                            BreedListRow(item: item)
                        }
                    }
                }

            case let .failure(error):
                VStack {
                    VStack {
                        TaskFailedView()

                        Text(error.localizedDescription)
                    }

                    Button {
                        id = .init()
                    } label: {
                        Label("Reload", systemImage: "arrow.triangle.2.circlepath")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }

            case .none:
                ProgressView()
            }
        }
        .task(id: id) {
            guard loadedID != id else { return } // Load only once unless reloading by button
            loadedID = id
            breeds = .loading
            do {
                let breedList = try await dependency.getBreedList()
                breeds = .loaded(.success(breedList.map()))
            } catch {
                breeds = .loaded(.failure(error))
            }
        }
    }
}

struct BreedListRow: View {
    let item: BreedListItem

    @State private var isExpanded = true

    var body: some View {
        switch item {
        case let .group(breed, subBreeds):
            DisclosureGroup(isExpanded: $isExpanded) {
                ForEach(subBreeds, id: \.self) { subBreed in
                    NavigationLink(value: BreedListScreen.Destination.breedImage(breed: subBreed)) {
                        Text(subBreed, format: .breedName)
                    }
                }
            } label: {
                NavigationLink(value: BreedListScreen.Destination.breedImage(breed: breed)) {
                    Text(breed, format: .breedName)
                }
            }

        case let .concrete(breed):
            NavigationLink(value: BreedListScreen.Destination.breedImage(breed: breed)) {
                Text(breed, format: .breedName)
            }
        }
    }
}

enum BreedListItem: Hashable {
    case group(breed: ConcreteBreed, subBreeds: [ConcreteBreed])

    case concrete(ConcreteBreed)

    var breed: Breed {
        switch self {
        case let .group(breed, _), let .concrete(breed):
            return breed.breed
        }
    }
}

extension BreedList {
    func map() -> [BreedListItem] {
        reduce(into: []) { partialResult, item in
            let breed = ConcreteBreed(breed: item.key, subBreed: nil)
            if item.value.isEmpty {
                partialResult.append(.concrete(breed))
            } else {
                let subBreeds = item.value
                    .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
                    .map { ConcreteBreed(breed: breed.breed, subBreed: $0) }
                partialResult.append(.group(breed: breed, subBreeds: subBreeds))
            }
        }
        .sorted { $0.breed.localizedStandardCompare($1.breed) == .orderedAscending }
    }
}

enum LoadingState<Success> {
    case notStarted

    case loading

    case loaded(Result<Success, Error>)

    var result: Result<Success, Error>? {
        switch self {
        case .notStarted, .loading:
            return nil

        case let .loaded(result):
            return result
        }
    }

    var isLoaded: Bool {
        result != nil
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

struct TaskFailedView: View {
    var body: some View {
        Image(systemName: "xmark")
            .symbolRenderingMode(.multicolor)
            .imageScale(.large)
            .padding()
    }
}

struct GenericError: LocalizedError {
    let message: String

    var errorDescription: String? {
        message
    }
}

extension Error where Self == GenericError {
    static func message(_ message: String) -> Self {
        .init(message: message)
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
