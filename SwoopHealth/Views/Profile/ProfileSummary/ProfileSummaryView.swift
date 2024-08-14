//
//  ProfileSummaryView.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/21/24.
//

import SwiftUI

struct ProfileSummaryView: View {
    
    let prescriptions: [String] = [
        "Drug name",
        "Drug name",
        "Drug name"
    ]
    
    let nextAppointment: String = "10/20/2024"
    
    var body: some View {
        ScrollView {
            VStack {
                backButton
                    .padding()
                // image
                image
                    .padding()
                
                // doctor
                VStack(alignment: .leading, spacing: 0) {
                    Text("Doctor")
                        .padding(.horizontal)
                    HStack {
                        Spacer()
                        Text("Dr. Bones")
                        Spacer()
                    }
                    .padding()
                    .background {
                        Color(.systemGray6).cornerRadius(16)
                    }
                    .padding()
                }
                
                // prescriptions
                VStack(alignment: .leading, spacing: 0) {
                    Text("Prescriptions")
                        .padding(.horizontal)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(prescriptions, id: \.self) { item in
                                Text(item)
                                    .padding()
                                    .background {
                                        RoundedRectangle(cornerRadius: 16)
                                            .foregroundStyle(Color(.systemGray6))
                                    }
                            }
                        }
                        .padding()
                    }
                }
                
                // appointments
                VStack(alignment: .leading, spacing: 0) {
                    Text("appointments")
                        .padding(.horizontal)
                    HStack {
                        Text(nextAppointment)
                        Spacer()
                        Text("Directions")
                    }
                    .padding()
                    .background {
                        Color(.systemGray6).cornerRadius(16)
                    }
                    .padding()
                }
                
                // messages
                VStack(alignment: .leading, spacing: 0) {
                    Text("Messages")
                        .padding(.horizontal)
                    HStack(spacing: 10) {
                        Circle()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .leading) {
                            Text("Dr Bones")
                            Text("Wanted to remind you of an appointment comming up!")
                                .lineLimit(1)
                        }
                        Spacer()
                        Text("5h")
                    }
                    .padding()
                    .background {
                        Color(.systemGray6).cornerRadius(16)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ProfileSummaryView()
}

extension ProfileSummaryView {
    private var backButton: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color(.label))
            }

            Spacer()
        }
        .padding(.bottom)
    }
    
    private var image: some View {
        HStack(spacing: 15) {
            Circle()
                .frame(width: 70, height: 70)
            VStack(alignment: .leading, spacing: 5) {
                name
                age
            }
            Spacer(minLength: 0)
        }
    }
    
    private var name: some View {
        Text("Jacob Lucas")
            .font(.system(size: 20, weight: .medium))
    }
    
    private var age: some View {
        Text("07/26/2001")
            .font(.system(size: 16))
    }
    
    private var doctor: some View {
        Text("Doctor")
    }
    
    private var messages: some View {
        Text("Messages")
    }

    private var appointments: some View {
        Text("Appointments")
    }
}

struct DetailedListItem: View {
    let title: String
    let content: String
    
    let hideIcon: Bool?
    
    init(title: String, content: String, hideIcon: Bool? = nil) {
        self.title = title
        self.content = content
        self.hideIcon = hideIcon
    }
    
    var body: some View {
        HStack(spacing: 15) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
            Text(content)
                .font(.system(size: 14, weight: .medium))
            Spacer()
            if hideIcon == nil {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
            }
        }
        .padding(8)
        .padding(.vertical, 3)
    }
}
