//
//  MessageView.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/21/24.
//

import SwiftUI

struct MessageView: View {
    
    let user: UserModel
    let secondUserID: String
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MessageViewModel
    
    init(user: UserModel, secondUserID: String) {
        self.user = user
        self.secondUserID = secondUserID
        self.viewModel = MessageViewModel(secondUserID: secondUserID)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack(spacing: 8) {
                    Circle()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(Color.theme.blue)
                        .overlay {
                            Text(String(user.name.first!))
                                .foregroundStyle(.white)
                                .font(.system(size: 13, weight: .medium))
                        }
                    
                    Text(user.name)
                }
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16))
                    }
                    .buttonStyle(ButtonScaleEffectStyle())
                    
                    Spacer()
                }
            }
            .padding(12)
            .font(.system(size: 15, weight: .medium))
            Divider()
            
            if (viewModel.messages.isEmpty) {
                Rectangle()
                    .foregroundStyle(Color(.systemGray6))
                    .overlay {
                        Text("Send the first message.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color(.systemGray))
                    }
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            Message(message: message)
                        }
                    }
                    .padding(12)
                }
                .background {
                    Color(.systemGray6)
                }
            }
            
            Divider()
            HStack {
                TextField("Send a message", text: $viewModel.message)
                
                Button {
                    viewModel.sendMessage()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title)
                }
            }
            .padding([.vertical, .leading], 6)
            .padding(.horizontal, 6)
            .background {
                ZStack {
                    Group {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundStyle(Color(.systemGray6))
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(Color(.systemGray5))
                    }
                    .frame(height: 46)
                }
            }
            .padding(12)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MessageView(
        user: UserModel(
            id: "",
            name: "",
            dob: "",
            email: "",
            phone: "", 
            type: .patient,
            doctor: ""
        ),
        secondUserID: ""
    )
}
