//
//  CountDownTimeLabel.swift
//  CountDown
//
//  Created by Dmitrii Kuragin on 12/02/2017.
//  Copyright © 2023 Dmitrii Kuragin. All rights reserved.
//

import Foundation
import SwiftUI

struct TimerLabel: View {
    @Binding var timeInterval: String
    
    var body: some View {
        ZStack {
            Text(timeInterval)
                .font(.custom("HelveticaNeue-Light", size: 400.0))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .lineLimit(1)
                .minimumScaleFactor(0.001)
        }
    }
}

struct TimerLabel_Previews: PreviewProvider {
    static var previews: some View {
        TimerLabel(timeInterval: .constant("29.98"))
            .background(.black)
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("landscape")
        
        TimerLabel(timeInterval: .constant("29.98"))
            .background(.black)
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewInterfaceOrientation(.portrait)
            .previewDisplayName("portrait")
    }
}
