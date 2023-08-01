//
//  MacUI.swift
//  
//
//  Created by Mikhail Apurin on 02.08.2023.
//

import SwiftUI

struct MyView: View {
    var body: some View {
        Text("Hello, World!")
            .cuttable(for: String.self) {
                []
            }
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
    }
}
