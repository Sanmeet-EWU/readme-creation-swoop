//
//  ProfileView.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/10/24.
//

import SwiftUI

struct ProfileView: View {
    
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
                        signOut()
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
        }
    }
    
    private func signOut() {
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
        .preferredColorScheme(.light)
}

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
