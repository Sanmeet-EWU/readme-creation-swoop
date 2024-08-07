//
//  InfoSheet.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/13/24.
//

import SwiftUI

struct InfoSheet: View {
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var sheetContentHeight = CGFloat(0)
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 38, height: 4)
                .foregroundStyle(Color(.systemGray5))
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Creating an Account")
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                }
                Text("To create a Swoop account, please contact your physician's office. You can reach them by email at tommy@swoop.com or by phone at 509-532-6432.")
                    .font(.system(size: 14, weight: .light))
                    .lineSpacing(4)
            }
            .padding(.vertical)

        }
        .padding(.horizontal)
        .padding(.bottom)
        .textFieldStyle(PlainTextFieldStyle())
        .fixedSize(
            horizontal: false,
            vertical: true
        )
        .background {
            GeometryReader { proxy in
                Color.clear.task {
                    sheetContentHeight = proxy.size.height
                }
            }
        }
        .presentationDetents([.height(sheetContentHeight)])
    }
}

#Preview {
    InfoSheet()
}
