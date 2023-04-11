//
//  SettingsView.swift
//  CountDown
//
//  Created by Dmitrii Kuragin on 4/10/23.
//  Copyright © 2023 Kuragin Dmitriy. All rights reserved.
//

import SwiftUI

struct VibrationRow: View {
    @Binding var isOn: Bool
    
    var body: some View {
        return HStack {
            Toggle("Vibration", isOn: $isOn)
        };
    }
}

struct SettingsView: View {
    @Binding var vibration: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            NavigationView {
                List {
                    VibrationRow(isOn: $vibration)
                }
            }   .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem (placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(vibration: .constant(true))
    }
}
