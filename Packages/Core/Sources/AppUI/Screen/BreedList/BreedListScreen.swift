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
        WithViewDataCollection(breeds) { breeds in
            List {
                Section {
                    breeds.forEach { item in
                        BreedListRow(item: item.element)
                    }
                }
            }
            .refreshable {
                await breeds.handle(.refresh)?.value
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
