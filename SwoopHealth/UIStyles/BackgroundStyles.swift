//
//  BackgroundStyles.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/10/24.
//

import SwiftUI

public enum UI {
    enum TextFieldBackground {
        static func inner() -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 9)
                    .foregroundStyle( Color(.systemGray6))
                RoundedRectangle(cornerRadius: 9)
                    .stroke(lineWidth: 1)
                    .foregroundStyle( Color(.systemGray4))
            }
        }
        
        static func outer(colorScheme: ColorScheme) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 13)
                    .foregroundStyle(colorScheme == .light ? .white : .black)
                RoundedRectangle(cornerRadius: 13)
                    .stroke(lineWidth: 1)
                    .foregroundStyle( Color(.systemGray4))
            }
        }
    }
}
