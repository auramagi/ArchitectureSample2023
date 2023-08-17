//
//  RandomImageFlow.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Core
import SwiftUI

struct RandomImageFlow<Container: AppUIContainer>: View {
    let container: Container

    var body: some View {
        let service = RandomDogImageService(dependency: .init(getRandomDogImage: container.dogRepository.getRandomDogImage, sendError: container.displayableErrorRepository.sendError(_:)))

        NavigationStack {
            DogImageScreen(dependency: .init(getDogImage: service.getRandomDogImage))
                .navigationTitle("Random Dog")
        }
    }
}
