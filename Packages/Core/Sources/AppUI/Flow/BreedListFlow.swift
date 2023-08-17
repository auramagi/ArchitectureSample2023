//
//  BreedListFlow.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Core
import SwiftUI

struct BreedListFlow<Container: AppUIContainer>: View {
    let container: Container

    var body: some View {
        NavigationStack {
            BreedListScreen(
                breeds: container.localDogBreedRepository.viewData()
            )
            .navigationTitle("Breeds")
            .navigationDestination(for: BreedListScreenDestination.self) { destination in
                switch destination {
                case let .breedImage(breed):
                    breedImageDestination(breed: breed)
                }
            }
        }
    }

    @ViewBuilder func breedImageDestination(breed: ConcreteBreed) -> some View {
        DogImageScreen(dependency: .init(
            getDogImage: { await container.makeDogBreedImageService().getDogBreedImage(breed: breed) }
        ))
        .navigationTitle(breed.formatted(.breedName))
    }
}

struct BreedListFlow_Previews: PreviewProvider {
    static var previews: some View {
        BreedListFlow(container: .preview())
    }
}
