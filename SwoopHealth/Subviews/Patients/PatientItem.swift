//
//  PatientItem.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/7/24.
//

import SwiftUI

struct PatientItem: View {
    
    let patient: UserModel
    
    @ObservedObject var viewModel: PatientsViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.toggleFavorite(patient: patient)
            } label: {
                Image(systemName: viewModel.favoritePatients.contains(patient.id) ? "bookmark.fill" : "bookmark")
                    .foregroundStyle(Color.theme.blue)
            }

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
