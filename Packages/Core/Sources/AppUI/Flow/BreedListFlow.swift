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
