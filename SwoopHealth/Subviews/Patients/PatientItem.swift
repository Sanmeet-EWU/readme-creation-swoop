//
//  PatientItem.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/7/24.
//

import SwiftUI

struct PatientItem: View {
    
    let user: UserModel
    
    @ObservedObject var viewModel: PatientsViewModel
    @AppStorage("doctor") var currentUserDoctor: String?
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.toggleFavorite(patient: user)
            } label: {
                Image(systemName: viewModel.favoritePatients.contains(user.id) ? "bookmark.fill" : "bookmark")
                    .foregroundStyle(Color.theme.blue)
            }

            Circle()
                .frame(width: 48, height: 48)
                .foregroundStyle(Color.theme.blue)
                .overlay {
                    Text(String(user.name.first!))
                        .foregroundStyle(.white)
                        .font(.system(size: 22, weight: .medium))
                }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(user.name)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color(.label))
                    
                    if let doctor = currentUserDoctor, doctor == user.name {
                        Text("current")
                            .padding(4)
                            .padding(.horizontal, 5)
                            .font(.system(size: 12))
                            .foregroundStyle(.white)
                            .background {
                                Capsule()
                                    .foregroundStyle(Color.theme.blue)
                            }
                    }
                }
                Text(user.email)
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

struct DoctorItem: View {
    
    let user: UserModel
    
    @ObservedObject var viewModel: DoctorListViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.toggleFavorite(doctor: user)
            } label: {
                Image(systemName: viewModel.favoriteDoctors.contains(user.id) ? "bookmark.fill" : "bookmark")
                    .foregroundStyle(Color.theme.blue)
            }

            Circle()
                .frame(width: 48, height: 48)
                .foregroundStyle(Color.theme.blue)
                .overlay {
                    Text(String(user.name.first!))
                        .foregroundStyle(.white)
                        .font(.system(size: 22, weight: .medium))
                }
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color(.label))
                Text(user.email)
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
