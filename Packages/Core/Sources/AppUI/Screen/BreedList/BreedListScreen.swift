//
//  BreedListScreen.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Core
import SwiftUI

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

struct BreedListScreen_Previews: PreviewProvider {
    static let container = PreviewContainer()

    static var previews: some View {
        BreedListScreen(dependency: .init(getBreedList: container.dogRepository.getBreedList))
    }
}
