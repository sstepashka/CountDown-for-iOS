//
//  ContentView.swift
//  CountDown
//
//  Created by Dmitrii Kuragin on 3/26/23.
//  Copyright © 2023 Dmitrii Kuragin. All rights reserved.
//

import SwiftUI
import Dispatch

struct MyBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> BackgroundView {
        return BackgroundView()
    }
    
    func updateUIView(_ uiView: BackgroundView, context: Context) {
        
    }
}

struct TimerLabel: UIViewRepresentable {
    @Binding var timeInterval: TimeInterval
    
    func makeUIView(context: Context) -> CountDownTimeLabel {  
        let label = CountDownTimeLabel()
        label.timeInterval = 30.0
        return label
    }
    
    func updateUIView(_ uiView: CountDownTimeLabel, context: Context) {
        uiView.timeInterval = timeInterval
    }
}

struct TimerView: View {
    var body: some View {
        MyBackgroundView()
    }
}

class ViewModel: ObservableObject {
    @Published var timeInterval: TimeInterval = 30.0
    
    private var timer: CountDownTimer!
    
    init() {
        self.timer = CountDownTimer { newTimeInterval in
            DispatchQueue.main.async {
                self.timeInterval = newTimeInterval
            }
        }
    }
    
    func toggle() {
        self.timer.toggle()
    }
}

struct ContentView: View {
    @State var timeInterval: TimeInterval = 30.0
    @State var showSettings: Bool = false
    @State var vibration: Bool = false
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            MyBackgroundView()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button("Settings") {
                        viewModel.timeInterval = 20
                        showSettings.toggle()
                    }.padding().foregroundColor(.white)
                }
                TimerLabel(timeInterval: $viewModel.timeInterval)
                    .padding()
                    .gesture(
                        TapGesture().onEnded({
                            viewModel.toggle()
                        }))
                Text(LocalizedStringKey("With Love For You"))
                    .foregroundColor(.white)
                    .padding()
                    .font(Font.custom("Zapfino", size: 14.0))
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
