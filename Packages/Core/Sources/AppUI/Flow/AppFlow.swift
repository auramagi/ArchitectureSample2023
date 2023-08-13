//
//  AppFlow.swift
//  
//
//  Created by Mikhail Apurin on 01.08.2023.
//

import Core
import SwiftUI

public struct AppFlow<Container: AppContainer>: View {
    let container: Container

    public init(container: Container) {
        self.container = container
    }
    
    public var body: some View {
        NavigationStack {
            List {
                let collection = container.tagRepository.makeTagsContainer()
                collection.view { value in
                    VStack(alignment: .leading) {
                        Text(value.element.name)
                        
                        Button("Delete", role: .destructive) {
                            value.handle(action: .delete)
                        }
                    }
                }
                .onDelete { offsets in
                    collection.handle(action: .delete(offsets: offsets))
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        let tag = Tag(name: UUID().uuidString)
                        container.tagRepository.addTag(tag)
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Tag list")
        }
    }
}

struct AppFlow_Previews: PreviewProvider {
    static let container = PreviewContainer()
    static var previews: some View {
        AppFlow(container: container)
    }
}
