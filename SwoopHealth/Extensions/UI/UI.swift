//
//  UI.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/16/24.
//

import SwiftUI

extension UI {
    enum Background {
        static func newDefault() -> some View {
            @Environment(\.colorScheme) var colorScheme
            return VStack {
                if (colorScheme == .light) {
                    Color.white.ignoresSafeArea()
                } else {
                    Color.black.ignoresSafeArea()
                }
            }
        }
    }
}
