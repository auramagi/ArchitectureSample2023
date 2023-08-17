//
//  TaskFailedView.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import SwiftUI

struct TaskFailedView: View {
    var body: some View {
        Image(systemName: "xmark")
            .symbolRenderingMode(.multicolor)
            .imageScale(.large)
            .padding()
    }
}

struct TaskFailedView_Previews: PreviewProvider {
    static var previews: some View {
        TaskFailedView()
    }
}
