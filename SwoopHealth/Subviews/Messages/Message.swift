//
//  Message.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/23/24.
//

import SwiftUI

struct Message: View {
    let message: MessageModel
    let isSender: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    init(message: MessageModel) {
        @AppStorage("user_id") var currentUserID: String?
        
        self.message = message
        self.isSender = (message.senderID == currentUserID)
    }
    
    var body: some View {
        HStack {
            if (isSender) {
                Spacer()
            }
            
            Text(message.content)
                .font(.system(size: 16))
                .padding(8)
                .padding(.horizontal, 4)
                .foregroundStyle(!isSender ? Color(.label) : .white)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(!isSender ? (colorScheme == .light ? .white : .black) : .accentColor)
                }
            
            if (!isSender) {
                Spacer()
            }
        }
        .padding(.trailing, !isSender ? 80 : 0)
        .padding(.leading, !isSender ? 0 : 80)
    }
}

#Preview {
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        Message(message: MessageModel(
            senderID: "asg",
            name: "Dr.Bones",
            content: "Hello, how are you? aosndgaosdnfasdnfasoldnvlkasndvksdnvlaksdnvlkasdnvlkasdnvlkasdnvlkasdnvlksdnvlk",
            date: Date()
        ))
    }
}
