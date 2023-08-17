//
//  MainTabFlow.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Core
import SwiftUI

public struct MainTabFlow<Container: AppUIContainer>: View {
    let container: Container

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
    }

    @ViewBuilder var randomImageDestination: some View {
        RandomImageFlow(container: container)
    }

    @ViewBuilder var breedListDestination: some View {
        BreedListFlow(container: container)
    }
}

struct MainTabFlow_Previews: PreviewProvider {
    static let container = PreviewContainer()

    static var previews: some View {
        MainTabFlow(container: container)
    }
}
