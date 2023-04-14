//
//  AppIntentsExtension.swift
//  AppIntentsExtension
//
//  Created by Dmitrii Kuragin on 2/27/23.
//  Copyright © 2023 Dmitrii Kuragin. All rights reserved.
//

import AppIntents

struct AppIntentsExtension: AppIntent {
    static var title: LocalizedStringResource = "AppIntentsExtension"

    func perform() async throws -> some IntentResult {
        return .result()
    }
}
