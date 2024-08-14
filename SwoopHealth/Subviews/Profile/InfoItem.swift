//
//  InfoItem.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/13/24.
//

import SwiftUI

struct InfoItem: View {
    let emoji: String
    let title: String
    let description: String
    var body: some View {
        VStack(spacing: 3) {
            Text(emoji)
                .padding(12)
                .background {
                    Circle()
                        .foregroundStyle(Color(.systemGray6))
                        .opacity(0.5)
                }
            Text(title)
                .font(.system(size: 13, weight: .medium))
            Text(description)
                .font(.system(size: 12))
                .foregroundStyle(Color(.systemGray))
        }
        .padding(.vertical, 6)
    }
}
