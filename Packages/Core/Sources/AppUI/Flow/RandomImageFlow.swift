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
        NavigationStack {
            DogImageScreen(dependency: .init(
                getDogImage: container.makeRandomDogImageService().getRandomDogImage
            ))
            .navigationTitle("Random Dog")
        }
    }
}

struct RandomImageFlow_Previews: PreviewProvider {
    static var previews: some View {
        RandomImageFlow(container: .preview())
    }
}
