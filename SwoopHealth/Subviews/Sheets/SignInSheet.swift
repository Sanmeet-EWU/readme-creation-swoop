//
//  SignInSheet.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/13/24.
//

import SwiftUI

struct SignInSheet: View {
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var isLoading: Bool = false
    @State var signingInError: Bool = false
    
    @State var sheetContentHeight = CGFloat(0)
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 38, height: 4)
                .foregroundStyle(Color(.systemGray5))
            
            VStack(spacing: 10) {
                TextField("email", text: $email)
                TextField("password", text: $password)
            }
            .padding(.vertical, 25)
            .autocorrectionDisabled()
            .autocapitalization(.none)
            
            Button {
                signIn()
            } label: {
                if (isLoading) {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Sign In")
                }
            }
            .buttonStyle(CapsuleButtonStyle(
                textColor: .white,
                backgroundColor: Color.theme.darkBlue)
            )
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
        .alert(isPresented: $signingInError) {
            SwiftUI.Alert(
                title: Text("Error"),
                message: Text("Please verify your credentials and try again."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func signIn() {
        Task {
            isLoading = true
            let authInstance = AuthService.shared
            
            try await authInstance.signInWithEmail(email: email, password: password) { (isError) in
                if (isError) {
                    isLoading = false
                    signingInError = true
                    return
                }
                
                isLoading = false
            }
        }
    }
}

#Preview {
    SignInSheet()
}
