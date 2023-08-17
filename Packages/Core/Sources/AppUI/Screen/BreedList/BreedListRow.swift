//
//  BreedListRow.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Core
import SwiftUI

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
