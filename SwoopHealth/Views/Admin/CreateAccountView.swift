//
//  CreateAccountView.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/23/24.
//

import SwiftUI

struct CreateAccountView: View {
    
    @StateObject var viewModel = CreateAccountViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            CreateUserTitle(selectedView: $viewModel.selectedView)
            
            switch (viewModel.selectedView) {
            case 0:
                AccountTypeSelection(viewModel: viewModel)
            case 1:
                UserInfo(viewModel: viewModel)
            case 2:
                UserCredentials(viewModel: viewModel)
            case 3:
                DoctorTypeSelection(viewModel: viewModel)
            default:
                Text("Error")
            }
        }
        .textFieldStyle(PlainTextFieldStyle())
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color(.systemGray5))
        }
        .padding(12)
        .alert(isPresented: $viewModel.success) {
            SwiftUI.Alert(
                title: Text("Success"),
                message: Text("Account has been created successfully."),
                dismissButton: .default(Text("OK")) {
                    viewModel.resetAccountCreation()
                }
            )
        }
    }
}

#Preview {
    CreateAccountView()
}

struct DoctorTypeSelection: View {
    @ObservedObject var viewModel: CreateAccountViewModel
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Button {
                        viewModel.selectedView -= 1
                    } label: {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    Spacer()
                    Button {
                        viewModel.createAccount()
                    } label: {
                        if (viewModel.isLoading) {
                            ProgressView()
                        } else {
                            Text("Finish")
                        }
                    }
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color(.label))
                .padding()
            }
            
            VStack(spacing: 12) {
                HStack {
                    Text("Assign the patient a doctor.")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.bottom)
                    Spacer()
                }
                
                ForEach(viewModel.doctors, id: \.self) { doctor in
                    Button {
                        viewModel.doctor = doctor
                    } label: {
                        AccountTypeCell(
                            name: doctor,
                            isSelected: doctor == viewModel.doctor
                        )
                    }
                }
            }
        }
    }
}

struct UserCredentials: View {
    @ObservedObject var viewModel: CreateAccountViewModel
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Button {
                        viewModel.selectedView -= 1
                    } label: {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    Spacer()
                    Button {
                        if (viewModel.userType == .patient) {
                            viewModel.selectedView += 1
                        } else {
                           // Create Account
                            viewModel.createAccount()
                        }
                    } label: {
                        if (viewModel.userType == .patient) {
                            HStack {
                                Text("Next")
                                Image(systemName: "chevron.right")
                            }
                        } else {
                            if (viewModel.isLoading) {
                                ProgressView()
                            } else {
                                Text("Finish")
                            }
                        }
                    }
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color(.label))
                .padding()
            }
            
            VStack(spacing: 12) {
                HStack {
                    Text("Create their credentials.")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.bottom)
                    Spacer()
                }
                TextField("Email", text: $viewModel.email)
                TextField("password", text: $viewModel.password)
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
        }
    }
}

struct UserInfo: View {
    @ObservedObject var viewModel: CreateAccountViewModel
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Button {
                        viewModel.selectedView -= 1
                    } label: {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    Spacer()
                    Button {
                        viewModel.selectedView += 1
                    } label: {
                        HStack {
                            Text("Next")
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color(.label))
                .padding()
            }
            
            VStack(spacing: 12) {
                HStack {
                    Text("Tell us about them.")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.bottom)
                    Spacer()
                }
                TextField("Name", text: $viewModel.name)
                TextField("Phone Number", text: $viewModel.phoneNumber)
                TextField("Date of Birth", text: $viewModel.dateOfBirth)
            }
        }
    }
}

struct AccountTypeSelection: View {
    @ObservedObject var viewModel: CreateAccountViewModel
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        viewModel.selectedView += 1
                    } label: {
                        HStack {
                            Text("Next")
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color(.label))
                .padding()
            }
            
            VStack(spacing: 12) {
                HStack {
                    Text("Who is the\naccount for?")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.bottom)
                    Spacer()
                }
                
                ForEach(UserTypeEnum.allCases, id: \.self) { user in
                    Button {
                        viewModel.userType = user
                        print("User Type: ", viewModel.userType ?? "nil")
                    } label: {
                        if let userID = viewModel.userType?.id {
                            AccountTypeCell(
                                name: user.rawValue,
                                isSelected: userID == user.id
                            )
                        } else {
                            AccountTypeCell(
                                name: user.rawValue,
                                isSelected: false
                            )
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 12)
    }
}

struct CreateUserTitle: View {
    @Binding var selectedView: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Create Account")
                .font(.system(size: 16, weight: .medium))
                .padding(.vertical, 6)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 8)
                    .foregroundStyle(Color(.systemGray6))
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: indicatorWidth, height: 8)
                    .foregroundStyle(Color.theme.blue)
                    .animation(.linear, value: selectedView)
            }
        }
    }
    
    private var indicatorWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        switch selectedView {
        case 0:
            return 0
        case 1:
            return screenWidth / 3
        case 2:
            return 2 * screenWidth / 3
        case 3:
            return .infinity
        default:
            return 50
        }
    }
}

struct AccountTypeCell: View {
    let name: String
    let isSelected: Bool
    var body: some View {
        ZStack {
            Capsule()
                .frame(height: 48)
                .foregroundStyle(isSelected ? Color.theme.blue : Color(.systemGray6))
            HStack {
                Spacer()
                Text(name)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(isSelected ? .white : Color(.label))
                Spacer()
            }
        }
    }
}
