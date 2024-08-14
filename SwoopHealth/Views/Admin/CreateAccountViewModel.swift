//
//  CreateAccountViewModel.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/23/24.
//

import SwiftUI
import Firebase

enum UserTypeEnum: String, CaseIterable, Identifiable, Codable, Equatable {
    case patient = "patient"
    case doctor = "doctor"
    case nurse = "nurse"
    case admin = "admin"
    var id: UserTypeEnum { self }
}

class CreateAccountViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var name: String = ""
    @Published var doctor: String = ""
    @Published var phoneNumber: String = ""
    @Published var dateOfBirth: String = ""
    
    @Published var userType: UserTypeEnum? = nil
    
    @Published var selectedView: Int = 0
    @Published var isLoading: Bool = false
    @Published var success: Bool = false
    
    let doctors: [String] = [
        "Dr. Smith", "Dr. Johnson", "Dr. Brown", "Dr. Taylor", "Dr. Anderson"
    ]

    
    func createAccount() {
        Task {
            do {
                isLoading = true
                let authInstance = AuthService.shared
                
                let user = try await authInstance.createAccountWithEmail(
                    email: email,
                    password: password
                )
                
                let userID = user.uid
                
                // Add user data to Firebase.
                self.addUserToFirebase(userID)
                isLoading = false
            } catch {
                print("Error creating user account: ", error)
                isLoading = false
            }
        }
    }
    
    private func addUserToFirebase(_ userID: String) {
        guard let userType = userType else {
            print("Error unwrapping user type.")
            return
        }
        
        let authInstance = AuthService.shared
        
        let userModel = UserModel(
            id: userID,
            name: self.name,
            dob: self.dateOfBirth,
            email: self.email,
            phone: self.phoneNumber,
            type: userType,
            doctor: doctor
        )
        
        authInstance.createNewUserInDatabase(userModel: userModel) { success in
            if (success) {
                self.success = true
                print("Success creating user account in Firebase.")
            } else {
                print("Unable to create user account in Firebase")
            }
        }
    }
    
    private func patientDoctor(_ userType: UserTypeEnum) -> String? {
        if (userType == .patient) {
            return doctor
        } else {
            return nil
        }
    }
    
    func resetAccountCreation() {
        email = ""
        password = ""
        name = ""
        doctor = ""
        phoneNumber = ""
        dateOfBirth = ""
        userType = nil
        selectedView = 0
    }
}
