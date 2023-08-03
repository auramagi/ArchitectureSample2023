//
//  AppFlow.swift
//  
//
//  Created by Mikhail Apurin on 01.08.2023.
//

import Core
import CoreUI
import SwiftUI

public struct AppFlow<Container: AppContainer>: View {
    let container: Container

    public init(container: Container) {
        self.container = container
    }
    
    public var body: some View {
        List {
//            container.tagRepository.makeTagList { tag in
//                Text(tag.name)
//            }
        }
    }
}

struct AppFlow_Previews: PreviewProvider {
    static let container = PreviewContainer()
    static var previews: some View {
        AppFlow(container: container)

    }
}
