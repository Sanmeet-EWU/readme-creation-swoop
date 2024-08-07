//
//  PatientsView.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/16/24.
//

import SwiftUI

struct PatientsView: View {

    @State var search: String = ""
    
    @StateObject var viewModel = PatientsViewModel()
    @AppStorage("user_type") var currentUserType: String?
    
    var filteredPatients: [UserModel] {
        if search.isEmpty {
            return viewModel.patients.filter {
                if let type = currentUserType, type == "patient" {
                    return $0.type.rawValue == "doctor" ||
                           $0.type.rawValue == "nurse" ||
                           $0.type.rawValue == "admin"
                } else {
                    return true
                }
            }
        } else {
            return viewModel.patients.filter {
                if let type = currentUserType, type == "patient" {
                    return ($0.type.rawValue == "doctor" ||
                            $0.type.rawValue == "nurse" ||
                            $0.type.rawValue == "admin") &&
                           ($0.name.lowercased().contains(search.lowercased()) ||
                            $0.email.lowercased().contains(search.lowercased()))
                } else {
                    return $0.name.lowercased().contains(search.lowercased()) ||
                           $0.email.lowercased().contains(search.lowercased())
                }
            }
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Patients")
                    .font(.system(size: 22, weight: .medium))
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.theme.blue)
                            .fontWeight(.medium)
                        TextField("Search by name or email", text: $search)
                    }
                    .padding(.horizontal)
                    .background {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(lineWidth: 1)
                                .foregroundStyle(Color(.systemGray5))
                                .frame(height: 42)
                        }
                    }
                    .padding(.vertical, 12)
                    
                    
                    Image(systemName: "slider.horizontal.3")
                        .foregroundStyle(.white)
                        .fontWeight(.medium)
                        .padding(.horizontal, 10)
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundStyle(Color.theme.blue)
                                    .frame(height: 42)
                            }
                        }
                }
                
                
                VStack(spacing: 0) {
                    ForEach(0..<filteredPatients.count, id: \.self) { index in
                        let patient = filteredPatients[index]
                        NavigationLink {
                            MessageView(
                                user: patient,
                                secondUserID: patient.id
                            )
                        } label: {
                            PatientItem(patient: patient)
                        }
                        .buttonStyle(ButtonScaleEffectStyle())
                    }
                }
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    PatientsView()
}

struct PatientItem: View {
    let patient: UserModel
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 48, height: 48)
                .foregroundStyle(Color.theme.blue)
                .overlay {
                    Text(String(patient.name.first!))
                        .foregroundStyle(.white)
                        .font(.system(size: 22, weight: .medium))
                }
            VStack(alignment: .leading, spacing: 4) {
                Text(patient.name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color(.label))
                Text(patient.email)
                    .font(.system(size: 14))
                    .foregroundStyle(Color(.systemGray))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .medium))
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.theme.blue)
                .opacity(0.05)
        }
        .padding(.top, 8)
    }
}
