//
//  MainView.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/13/24.
//

import SwiftUI

struct MainView: View {
    
    @State var index = 0
    @AppStorage("user_type") var currentUserType: String?
    
    var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    if let userType = currentUserType {
                        if userType == "admin" {
                            CreateAccountView()
                                .opacity(index == 0 ? 1 : 0)
                        } else {
                            HomeView()
                                .opacity(index == 0 ? 1 : 0)
                        }
                    }
                    
                    CalendarView()
                        .opacity(index == 1 ? 1 : 0)
                    
                    PatientsView()
                        .opacity(index == 2 ? 1 : 0)
                    
                    ProfileView()
                        .opacity(index == 3 ? 1 : 0)
                }
                
                Menu(index: $index)
            }
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainView()
}
