//
//  ListItem.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/13/24.
//

import SwiftUI

struct ListItem: View {
    let icon: String
    let title: String
    
    let hideIcon: Bool?
    let isLast: Bool
    
    init(icon: String, title: String, hideIcon: Bool? = nil, isLast: Bool = false) {
        self.icon = icon
        self.title = title
        self.hideIcon = hideIcon
        self.isLast = isLast
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                Spacer()
                if hideIcon == nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .medium))
                }
            }
            .padding(16)
            
            if (!isLast) {
                Rectangle()
                    .frame(height: 1)
                    .padding(.leading, 16)
                    .foregroundStyle(Color(.systemGray5))
            }
        }
    }
}
