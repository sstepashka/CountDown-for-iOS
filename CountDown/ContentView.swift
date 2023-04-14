//
//  ContentView.swift
//  CountDown
//
//  Created by Dmitrii Kuragin on 3/26/23.
//  Copyright © 2023 Dmitrii Kuragin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var showSettings: Bool = false
    @State var vibration: Bool = false

    @StateObject var viewModel = ViewModel()

    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button("Settings") {
                        showSettings.toggle()
                    }.padding().foregroundColor(.white)
                }
                TimerLabel(timeInterval: $viewModel.timeInterval)
                    .padding()
                    .gesture(
                        TapGesture().onEnded({
                            viewModel.toggle()
                        }))

            }
        }.sheet(isPresented: $showSettings) {
            SettingsView(vibration: $vibration)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
