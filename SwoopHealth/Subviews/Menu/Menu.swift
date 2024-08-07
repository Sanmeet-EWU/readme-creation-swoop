//
//  Menu.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/13/24.
//

import SwiftUI

struct Menu: View {
    
    let icons: [String] = [
        "house.fill",
        "calendar",
        "stethoscope",
        "person.fill"
    ]
    
    let iconsAdmin: [String] = [
        "person.3.fill",
        "calendar",
        "stethoscope",
        "person.fill"
    ]
    
    let titles: [String] = [
        "Home",
        "Events",
        "Patients",
        "Profile"
    ]
    
    let titlesAdmin: [String] = [
        "Admin",
        "Events",
        "Patients",
        "Profile"
    ]
    
    @Binding var index: Int
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("user_type") var currentUserType: String?
    
    var body: some View {
        HStack {
            ForEach(0..<icons.count, id: \.self) { icon in
                createIcon(icon)
            }
        }
        .padding(.top)
        .padding(.vertical, 4)
        .background {
            Rectangle()
                .foregroundStyle(colorScheme == .light ? .white : .black)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    Menu(index: .constant(0))
}

//MARK: MENU EXTENSION
extension Menu {
    func createIcon(_ icon: Int) -> some View {
        Button(action: {
            index = icon
        }) {
            VStack(spacing: 6) {
                Image(systemName: currentUserType == "admin" ? iconsAdmin[icon] : icons[icon])
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 17)
                
                Text(currentUserType == "admin" ? titlesAdmin[icon] : titles[icon])
                    .font(.system(size: 9))
            }
            .fontWeight(.medium)
            .frame(maxWidth: .infinity)
            .foregroundColor(currentUserType == "admin" ? (iconsAdmin[icon] == iconsAdmin[index] ? Color(.label) : Color(.systemGray2)) : (icons[icon] == icons[index] ? Color(.label) : Color(.systemGray2))
            )
            .opacity(icon == index ? 1 : 0.5)
        }
        .buttonStyle(ButtonScaleEffectStyle())
    }
}
