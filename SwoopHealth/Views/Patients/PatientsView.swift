//
//  PatientsView.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/16/24.
//

import SwiftUI

struct PatientsView: View {
    
    @StateObject var viewModel = PatientsViewModel()
    @AppStorage("user_type") var currentUserType: String?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Messages")
                    .font(.system(size: 22, weight: .medium))
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.theme.blue)
                            .fontWeight(.medium)
                        TextField("Search by name or email", text: $viewModel.search)
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
                
                if viewModel.favoriteFilteredPatients.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Bookmarked")
                            .font(.system(size: 14))
                            .foregroundStyle(Color(.systemGray3))
                        ForEach(0..<viewModel.favoriteFilteredPatients.count, id: \.self) { index in
                            let patient = viewModel.favoriteFilteredPatients[index]
                            NavigationLink {
                                MessageView(
                                    user: patient,
                                    secondUserID: patient.id
                                )
                            } label: {
                                PatientItem(
                                    user: patient,
                                    viewModel: viewModel
                                )
                            }
                            .buttonStyle(ButtonScaleEffectStyle())
                        }
                    }
                    .padding(.bottom, 12)
                }
                
                VStack(spacing: 0) {
                    ForEach(0..<viewModel.filteredPatients.count, id: \.self) { index in
                        let patient = viewModel.filteredPatients[index]
                        NavigationLink {
                            MessageView(
                                user: patient,
                                secondUserID: patient.id
                            )
                        } label: {
                            if (!viewModel.favoritePatients.contains(patient.id)) {
                                PatientItem(
                                    user: patient,
                                    viewModel: viewModel
                                )
                            }
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
