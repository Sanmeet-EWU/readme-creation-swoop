//
//  DoctorListView.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/12/24.
//

import SwiftUI

struct DoctorListView: View {
    
    @StateObject var viewModel = DoctorListViewModel()
    @AppStorage("user_type") var currentUserType: String?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .medium))
                        .padding(6)
                        .background {
                            Circle()
                                .foregroundStyle(Color(.systemGray6))
                        }
                }
                .buttonStyle(ButtonScaleEffectStyle())
                
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
                
                if viewModel.favoriteFilteredDoctors.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Bookmarked")
                            .font(.system(size: 14))
                            .foregroundStyle(Color(.systemGray3))
                        ForEach(0..<viewModel.favoriteFilteredDoctors.count, id: \.self) { index in
                            let doctor = viewModel.favoriteFilteredDoctors[index]
                            NavigationLink {
                                DoctorDetailsView(doctor: doctor)
                            } label: {
                                DoctorItem(
                                    user: doctor,
                                    viewModel: viewModel
                                )
                            }
                            .buttonStyle(ButtonScaleEffectStyle())
                        }
                    }
                    .padding(.bottom, 12)
                }
                
                VStack(spacing: 0) {
                    ForEach(0..<viewModel.filteredDoctors.count, id: \.self) { index in
                        let doctor = viewModel.filteredDoctors[index]
                        NavigationLink {
                            DoctorDetailsView(doctor: doctor)
                        } label: {
                            if (!viewModel.favoriteDoctors.contains(doctor.id)) {
                                DoctorItem(
                                    user: doctor,
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
    DoctorListView()
}
