//
//  ContentView.swift
//  CountDown
//
//  Created by Dmitrii Kuragin on 3/26/23.
//  Copyright © 2023 Kuragin Dmitriy. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RootViewController().ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RootViewController: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // N/A
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()!
    }
}
