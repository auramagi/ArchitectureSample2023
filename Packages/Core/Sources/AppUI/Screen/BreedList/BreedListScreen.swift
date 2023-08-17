//
//  BreedListScreen.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Core
import SwiftUI

struct BreedListScreen<ViewData: DogBreedViewData>: View {
    let breeds: ViewData

    var body: some View {
        breeds.build { collection in
            List {
                Section {
                    collection.forEach { item in
                        BreedListRow(item: item.element)
                    }
                }

            }
        }
    }
}

enum BreedListScreenDestination: Hashable {
    case breedImage(breed: ConcreteBreed)
}

struct BreedListScreen_Previews: PreviewProvider {
    static let container = PreviewContainer()

    static var previews: some View {
        BreedListScreen(breeds: container.localDogBreedRepository.viewData())
    }
}
