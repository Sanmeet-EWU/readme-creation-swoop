//
//  ButtonStyles.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/13/24.
//

import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    let textColor: Color
    let backgroundColor: Color
    let outlineColor: Color?
    
    init(textColor: Color, backgroundColor: Color, outlineColor: Color? = nil) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.outlineColor = outlineColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(height: 46)
                .foregroundColor(backgroundColor)
            configuration.label
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundColor(textColor)
            if let outline = outlineColor {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 1)
                    .frame(height: 46)
                    .foregroundColor(outline)
            }
        }
        .scaleEffect(configuration.isPressed ? 0.90 : 1)
    }
}

struct ButtonScaleEffectStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration
            .label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
