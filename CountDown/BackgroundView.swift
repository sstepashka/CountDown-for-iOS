//
//  BackgroundView.swift
//  CountDown
//
//  Created by Dmitrii Kuragin on 12/02/2017.
//  Copyright © 2023 Dmitrii Kuragin. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    .linearGradient(
                        Gradient(colors: [
                            Color(
                                red: 245.0 / 255.0,
                                green: 51.0 / 255.0,
                                blue: 146.0 / 255.0),
                            Color(
                                red: 184.0 / 255.0,
                                green: 40.0 / 255.0,
                                blue: 240.0 / 255.0),
                        ]),
                        startPoint: UnitPoint(x: 0.0, y: 0.0),
                        endPoint: UnitPoint(x: 0.0, y: 1.0)))
            VStack {
                Spacer()
                Text(LocalizedStringKey("With Love For You"))
                    .foregroundColor(.white)
                    .padding()
                    .font(Font.custom("Zapfino", size: 14.0))
            }
        }
    }
}

struct NBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView().ignoresSafeArea()
    }
}
