//
//  HomeView.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/13/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("user_type") var currentUserType: String?
    
    let names: [String] = [
        "Abby", "Jake", "Caitlyn", "Elon", "Mark", "Sofia",
    ]
    
    var body: some View {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    logo
                    orderInventory
                    upcomingAppointments
                    labResults
                    
                    if let userType = currentUserType,
                       userType == "Doctor" || userType == "Nurse" {
                        createOrder
                    }
                }
            }
    }
}

#Preview {
    HomeView()
}

extension HomeView {
    private var logo: some View {
        HStack(spacing: 10) {
            Image("swoop_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 32)
            
            Text("Swoop")
                .font(.system(size: 20, weight: .medium))
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
    
    private var upcomingAppointments: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Upcoming Events")
                .font(.system(size: 15, weight: .medium))
            
            VStack {
                Event(event: EventModel(user: UserModel(id: "", name: "Jacob Lucas", dob: "07/26/2001", email: "", phone: "", type: .patient, doctor: ""), eventDate: Date(), title: "Flu Shot", description: "Flu Shot"))
            }
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(Color(.systemGray5))
            }
        }
        .padding(.horizontal)
    }
    
    private var orderInventory: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.pink)
                        .font(.system(size: 77))
                        .opacity(0.2)
                    
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.pink)
                        .font(.system(size: 62))
                        .opacity(0.4)
                    
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.pink)
                        .font(.system(size: 47))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Current")
                        .font(.system(size: 14, weight: .medium))
                    HStack(alignment: .bottom) {
                        Text("105")
                            .font(.system(size: 28, weight: .medium))
                        Text("BPM")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.pink)
                    }
                    Text("88 BPM, 10m ago")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(.systemGray))
                }
                .padding(.leading, 12)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(Color(.systemGray6))
            }
        }
        .padding(.horizontal)
    }
    
    private var createOrder: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Create Order")
                .font(.system(size: 14, weight: .semibold))
            
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(colorScheme == .light ? .white : .black)
                .frame(height: UIScreen.main.bounds.height / 7)
                .shadow(color: .black.opacity(0.05), radius: 10)
        }
        .padding(.horizontal)
    }
    
    private var labResults: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(Color(.systemGray6))
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Search Doctors")
                                .font(.system(size: 22, weight: .semibold))
                            Text("Find skilled doctors in every field.")
                                .font(.system(size: 15))
                        }
                        Spacer()
                            
                    }
                    
                    Image("doctors")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 160)
                        .padding(.vertical, 18)
                    
                    Button {
                        
                    } label: {
                        Text("Search")
                    }
                    .buttonStyle(CapsuleButtonStyle(
                        textColor: .white,
                        backgroundColor: Color.theme.blue)
                    )
                }
                .padding()
            }
            .padding(.horizontal)
//            .frame(height: UIScreen.main.bounds.height / 3)
    }
}

struct AppointmentCell: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Appointment date")
                .font(.system(size: 13))
                .foregroundStyle(Color(.systemGray))
            
            HStack {
                HStack {
                    Image(systemName: "calendar")
                    Text("Today, July 10th")
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white)
                .padding(6)
                .padding(.horizontal, 4)
                .background {
                    Capsule()
                        .foregroundStyle(Color.theme.blue)
                }
                
                HStack {
                    Image(systemName: "clock")
                    Text("9:30 AM")
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white)
                .padding(6)
                .padding(.horizontal, 4)
                .background {
                    Capsule()
                        .foregroundStyle(Color.theme.blue)
                }
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(.systemGray6))
                .padding(.vertical, 8)
            
            HStack(spacing: 10) {
                Circle()
                    .frame(width: 35, height: 35)
                    .foregroundStyle(Color.theme.blue)
                    .overlay {
                        Text("J")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .medium))
                    }
                VStack(alignment: .leading) {
                    Text("Jacob Lucas")
                        .font(.system(size: 14, weight: .medium))
                    Text("patient")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(.systemGray))
                }
                
                Spacer()
                
                Image(systemName: "message.circle.fill")
                    .font(.system(size: 25))
            }
        }
        .padding(12)
    }
}
