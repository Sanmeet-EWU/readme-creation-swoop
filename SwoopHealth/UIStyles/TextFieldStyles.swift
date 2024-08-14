//
//  RoundedTextFieldStyle.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/10/24.
//

import SwiftUI

struct PlainTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(Color(.systemGray6))
                RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(Color(.systemGray5))
            }
            .frame(height: 46)
            
            configuration
                .padding(12)
                .padding(.horizontal, 2)
        }
    }
}

struct ClearTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color(.systemGray5))
                .frame(height: 46)
            
            configuration
                .padding(12)
                .padding(.horizontal, 2)
        }
    }
}
