//
//  UserFlow.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Core
import SwiftUI

struct UserFlow<Container: AppUIContainer>: View {
    let container: Container

    var body: some View {
        NavigationStack {
            UserScreen(userSettings: container.userSettingsRepository)
        }
    }
}

struct UserFlow_Previews: PreviewProvider {
    static var previews: some View {
        UserFlow(container: .preview())
    }
}
