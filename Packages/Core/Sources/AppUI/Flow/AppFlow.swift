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
        let service = DogService(dependency: .init(getRandomDog: container.dogRepository.getRandomDog, sendError: container.displayableErrorRepository.sendError(_:)))
        DogScreen(dependency: .init(getRandomDog: service.getRandomDog))
    }

    @ViewBuilder var breedListDestination: some View {
        NavigationStack {
            BreedListScreen(dependency: .init(
                getBreedList: container.dogRepository.getBreedList
            ))
        }
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
                    TaskFailedView()
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

struct BreedListScreen: View {
    struct Dependency {
        let getBreedList: () async throws -> BreedList
    }

    let dependency: Dependency

    @State private var breeds: LoadingState<[BreedListItem]> = .notStarted

    @State private var id = UUID()

    var body: some View {
        ZStack {
            switch breeds {
            case .notStarted, .loading:
                ProgressView()

            case let .loaded(.success(breeds)):
                List {
                    Section {
                        ForEach(breeds, id: \.self) { item in
                            BreedListRow(item: item)
                        }
                    }
                }

            case let .loaded(.failure(error)):
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
            }
        }
        .task(id: id) {
            breeds = .loading
            do {
                let breedList = try await dependency.getBreedList()
                breeds = .loaded(.success(breedList.map()))
            } catch {
                breeds = .loaded(.failure(error))
            }
        }
        .navigationTitle("Breeds")
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
                    Text(subBreed, format: .breedName)
                }
            } label: {
                Text(breed, format: .breedName)
            }

        case let .concrete(breed):
            Text(breed, format: .breedName)
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

struct ConcreteBreed: Hashable {
    let breed: Breed

    let subBreed: SubBreed?
}

extension ConcreteBreed {
    struct BreedNameFormatStyle: FormatStyle {
        let locale: Locale?

        func locale(_ locale: Locale) -> ConcreteBreed.BreedNameFormatStyle {
            .init(locale: locale)
        }

        func format(_ value: ConcreteBreed) -> String {
            if let subBreed = value.subBreed {
                return "\(subBreed) \(value.breed)".capitalized(with: locale)
            } else {
                return value.breed.capitalized(with: locale)
            }
        }
    }
}

extension FormatStyle where Self == ConcreteBreed.BreedNameFormatStyle {
    static var breedName: Self {
        .init(locale: nil)
    }
}

enum LoadingState<Success> {
    case notStarted
    case loading
    case loaded(Result<Success, Error>)
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
