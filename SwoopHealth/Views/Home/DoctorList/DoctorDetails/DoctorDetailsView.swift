//
//  DoctorDetailsView.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/12/24.
//

import SwiftUI

struct DoctorDetailsView: View {
    
    let doctor: UserModel
    
    @StateObject var viewModel = DoctorDetailsViewModel()
    
    @Environment(\.dismiss) var dismiss
    @AppStorage("user_id") var currentUserID: String?
    
    var body: some View {
        VStack(spacing: 12) {
            heading
            personalDetails
            careerDetails
            contactDetails
            Spacer()
            buttons
        }
        .padding(12)
        .navigationBarBackButtonHidden()
        .alert(isPresented: $viewModel.successAlert) {
            SwiftUI.Alert(
                title: Text("Success"),
                message: Text("Your doctor has been updated successfully."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    DoctorDetailsView(doctor: UserModel(
        id: "",
        name: "Thomas Edward",
        dob: "03/30/1980",
        email: "thomasedward@gmail.com",
        phone: "509-392-3924",
        type: .doctor,
        doctor: nil)
    )
}

extension DoctorDetailsView {
    private var heading: some View {
        HStack {
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
            Spacer()
        }
    }
    
    private var personalDetails: some View {
        VStack { 
            Circle()
                .frame(width: 80, height: 80)
                .foregroundStyle(Color.theme.blue)
                .overlay {
                    Text("J")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                }
            
            VStack(spacing: 6) {
                Text(doctor.name)
                    .font(.system(size: 18, weight: .medium))
                Text(doctor.email)
                    .font(.system(size: 18))
                    .foregroundStyle(Color(.systemGray))
            }
            .padding(.vertical)
        }
    }
    
    private var careerDetails: some View {
        VStack(spacing: 0) {
            DoctorListItem(
                icon: "calendar",
                title: "Birth",
                description: doctor.dob,
                hideIcon: true
            )
            DoctorListItem(
                icon: "briefcase.fill",
                title: "Experience",
                description: "15 years",
                hideIcon: true
            )
            DoctorListItem(
                icon: "checkmark.circle.fill",
                title: "Accepting Patients",
                description: "Yes",
                hideIcon: true
            )
            DoctorListItem(
                icon: "staroflife.fill",
                title: "Specialty",
                description: "Sight",
                hideIcon: true,
                isLast: true
            )
        }
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color(.systemGray6))
        }
    }
    
    private var contactDetails: some View {
        VStack(spacing: 0) {
            DoctorListItem(
                icon: "phone.fill",
                title: "Contact",
                description: doctor.phone,
                hideIcon: true
            )
            DoctorListItem(
                icon: "mappin.and.ellipse",
                title: "Location",
                description: "Seattle, WA",
                hideIcon: true,
                isLast: true
            )
        }
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color(.systemGray6))
        }
    }
    
    private var buttons: some View {
        VStack { 
            NavigationLink {
                if let userID = currentUserID {
                    MessageView(
                        user: doctor,
                        secondUserID: doctor.id
                    )
                }
            } label: {
                Text("Chat")
            }
            .buttonStyle(CapsuleButtonStyle(
                textColor: .white,
                backgroundColor: Color.theme.blue)
            )

            Button {
                viewModel.updateUserDoctor(doctorName: doctor.name)
            } label: {
                Text("Switch doctor")
            }
            .buttonStyle(CapsuleButtonStyle(
                textColor: Color(.label),
                backgroundColor: Color(.systemGray5))
            )
        }
    }
}
