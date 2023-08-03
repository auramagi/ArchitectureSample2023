//
//  ContentView.swift
//  
//
//  Created by Mikhail Apurin on 01.08.2023.
//

import SwiftUI

public struct ContentView: View {
    public init() { }
    
    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
