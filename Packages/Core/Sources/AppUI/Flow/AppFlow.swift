//
//  AppFlow.swift
//  
//
//  Created by Mikhail Apurin on 01.08.2023.
//

import Core
import SwiftUI

public struct AppFlow<Container: AppUIContainer>: View {
    let container: Container

    public init(container: Container) {
        self.container = container
    }
    
    public var body: some View {
        WithViewData(container.userSettingsRepository) { userSettings in
            ZStack {
                if userSettings.entity.didShowWelcome {
                    mainTabDestination
                } else {
                    welcomeDestination
                }
            }
            .animation(.default, value: userSettings.entity.didShowWelcome)
        }
        .modifier(DisplayableErrorAlertViewModifier(dependency: .init(error: { container.displayableErrorRepository.error }, clearError: container.displayableErrorRepository.clearError(id:))))
    }

    @ViewBuilder var mainTabDestination: some View {
        MainTabFlow(container: container)
    }

    @ViewBuilder var welcomeDestination: some View {
        WelcomeFlow(container: container)
    }
}

struct AppFlow_Previews: PreviewProvider {
    static var previews: some View {
        AppFlow(container: .preview())
            .previewDisplayName("Initial")

        AppFlow(container: .preview(.default.with(\.didShowWelcome, true)))
            .previewDisplayName("After dismissing Welcome")
    }
}

public struct TagsListView<Tags: TagRepository>: View {
    var tags: Tags

    @Environment(\.editMode) private var editMode

    public init(tags: Tags) {
        self.tags = tags
    }

    public var body: some View {
        WithViewDataCollection(tags) { tags in
            List {
                Section {
                    ForEach(tags) { value in
                        VStack(alignment: .leading) {
                            Text(value.entity.name)

                            Text(value.entity.state.uuidString)
                                .font(.caption2)
                                .foregroundColor(.secondary)

                            Button("Delete", role: .destructive) {
                                value.handle(.delete)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .id(value.entity.id)
                    }
                    .onDelete { offsets in
                        tags.handle(.delete(offsets: offsets))
                    }
                    .onMove { fromOffsets, toOffset in
                        tags.handle(.move(fromOffsets: fromOffsets, toOffset: toOffset))
                    }
                }

                Section {
                    Button {
                        tags.handle(.add(tag: .init(name: UUID().uuidString)))
                    } label: {
                        LabeledContent {
                            Image(systemName: "plus")
                        } label: {
                            Text("Add")
                        }
                    }
                    .foregroundStyle(.green)
                }
            }
        }
    }
}

struct TagsListView_Previews: PreviewProvider {
    static let tags: some TagRepository = .mock(tags: [.init(name: "1"), .init(name: "2"), .init(name: "3")])

    static var previews: some View {
        NavigationStack {
            TagsListView(tags: tags)
                .toolbar {
                    #if os(iOS)
                    EditButton()
                    #endif
                }
        }
    }
}
