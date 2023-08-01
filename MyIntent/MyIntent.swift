//
//  MyIntent.swift
//  MyIntent
//
//  Created by Mikhail Apurin on 01.08.2023.
//

import AppIntents

struct MyIntent: AppIntent {
    static var title: LocalizedStringResource = "MyIntent"
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
