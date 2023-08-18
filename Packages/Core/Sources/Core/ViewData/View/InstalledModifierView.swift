//
//  InstalledModifierView.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/18.
//

import SwiftUI

struct InstalledModifierView<Modifier: DynamicProperty & ViewModifier, Content: View>: View {
    let modifier: Modifier

    @ViewBuilder let content: (Modifier) -> Content

    var body: some View {
        content(modifier)
            .modifier(modifier)
    }
}
