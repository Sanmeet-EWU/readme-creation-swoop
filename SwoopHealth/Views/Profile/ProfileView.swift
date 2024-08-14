//
//  ProfileView.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/10/24.
//

import SwiftUI

struct ProfileView: View {
    
    @State var logOutAlert: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("name") var currentUserName: String?
    @AppStorage("email") var currentUserEmail: String?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 3) {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .frame(width: 86, height: 86)
                        .foregroundStyle(Color.theme.blue)
                        .overlay {
                            if let name = currentUserName {
                                Text(String(name.first!))
                                    .foregroundStyle(.white)
                                    .font(.system(size: 30, weight: .medium))
                            }
                        }
                        .padding(.top, 12)
                    
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(Color.theme.darkBlue)
                        .background {
                            Circle()
                                .font(.system(size: 35))
                                .foregroundStyle(colorScheme == .light ? .white : .black)
                        }
                        .offset(x: 5, y: 5)
                }
                .padding()
                
                VStack(spacing: 2) {
                    if let name = currentUserName {
                        Text(name)
                            .font(.system(size: 18, weight: .medium))
                    }
                    
                    if let email = currentUserEmail {
                        Text(email)
                            .font(.system(size: 17))
                            .foregroundStyle(Color(.systemGray))
                            .disabled(true)
                    }
                    
                }
                .padding(.vertical, 10)
                
                VStack(spacing: 0) {
                    ListItem(
                        icon: "person.fill",
                        title: "Personal"
                    )
                    ListItem(
                        icon: "slider.horizontal.3",
                        title: "General"
                    )
                    ListItem(
                        icon: "bell.fill",
                        title: "Notifications",
                        isLast: true
                    )
                }
                .background {
                    RoundedRectangle(cornerRadius: 18)
                        .foregroundStyle(Color(.systemGray6))
                }
                .padding(.top)
                
                VStack(spacing: 0) {
                    ListItem(
                        icon: "questionmark.circle.fill",
                        title: "Help",
                        hideIcon: true
                    )
                    ListItem(
                        icon: "doc.plaintext.fill",
                        title: "Terms of Use",
                        hideIcon: true
                    )
                    ListItem(
                        icon: "lock.fill",
                        title: "Privacy Policy",
                        hideIcon: true
                    )
                    ListItem(
                        icon: "square.and.arrow.up.fill",
                        title: "Log Out",
                        hideIcon: true,
                        isLast: true
                    )
                    .onTapGesture {
                        logOutAlert.toggle()
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(Color(.systemGray6))
                }
                .padding(.top)
                
                Spacer()
            }
            .padding(.horizontal)
            .alert(isPresented: $logOutAlert) {
                SwiftUI.Alert(
                    title: Text("Log Out"),
                    message: Text("Are you sure you want to log out?"),
                    primaryButton: .destructive(Text("Log Out")) {
                        logOut()
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
    }
    
    private func logOut() {
        let authInstance = AuthService.shared
        
        Task {
            do {
                try await authInstance.signOut()
            } catch {
                print("Error signing user out: ", error)
            }
        }
    }
}

#Preview {
    ProfileView()
}
