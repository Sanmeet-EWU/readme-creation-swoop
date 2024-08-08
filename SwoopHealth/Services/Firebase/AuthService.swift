//
//  AuthService.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/15/24.
//

import SwiftUI
import Firebase

let D_BASE = Firestore.firestore()

class AuthService {
    
    static let shared = AuthService()
    
    private init() {}
    
    private var REF_USERS = D_BASE.collection("users")
    private var REF_DOCTORS = D_BASE.collection("doctors")
    
    @AppStorage("user_id") var currentUserID: String?
    
    //MARK: SIGN UP USER
    func createAccountWithEmail(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func createNewUserInDatabase(userModel: UserModel, completion: @escaping (_ success: Bool) -> ()
    ) {
        var userData = encodeToDictionary(from: userModel) ?? [:]
        
        if let doctor = userModel.doctor, !doctor.isEmpty {
            userData["doctor"] = doctor
            self.addPatientToDoctor(doctorName: doctor, patientID: userModel.id)
        }
        
        REF_USERS.document(userModel.id).setData(userData) { (error) in
            if let error = error {
                print("Error uploading data to user document. \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    private func encodeToDictionary<T: Codable>(from model: T) -> [String: Any]? {
        do {
            let jsonData = try JSONEncoder().encode(model)
            if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                return dictionary
            }
        } catch {
            print("Error encoding model: \(error.localizedDescription)")
        }
        return nil
    }
    
    private func addPatientToDoctor(doctorName: String, patientID: String) {
        REF_DOCTORS.document(doctorName).collection("patients").document(patientID).setData([
            "patient_id": patientID,
            "date": Date()
        ]) { (error) in
            if let error = error {
                print("Error adding patient to doctor. \(error)")
            } else {
                print("Patient added to doctor successfully.")
            }
        }
    }
    
    //MARK: SIGN IN USER
    func signInWithEmail(email: String, password: String, completion: @escaping (_ isError: Bool) -> ()) async throws {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        self.logInUserToFirebase(authDataResult: authDataResult) { (isError) in
            if (isError) {
                completion(true)
                return
            }
            completion(false)
            print("Success signing in with email.")
        }
    }
    
    private func logInUserToFirebase(authDataResult: AuthDataResult, completion: @escaping (_ isError: Bool) -> ()) {
        let authDataResultModel = AuthDataResultModel(user: authDataResult.user)
        let userID = authDataResultModel.uid
        
        self.checkIfUserExistsInDatabase(userID: userID) { (returnedUserID) in
            if let userID = returnedUserID {
                self.logInUserToApp(userID: userID) { (success) in
                    if (success) {
                        print("User successfully logged into app.")
                    }
                }
            } else {
                completion(true)
                print("There is no user account associated with this email and password combination.")
            }
        }
    }
    
    private func checkIfUserExistsInDatabase(userID: String, completion: @escaping (_ existingUserID: String?) -> ()) {
        REF_USERS.whereField("id", isEqualTo: userID).getDocuments { (querySnapshot, error) in
            if let snapshot = querySnapshot, snapshot.count > 0, let document = snapshot.documents.first {
                let existingUserID = document.documentID
                completion(existingUserID)
                return
            } else {
                completion(nil)
                return
            }
        }
    }
    
    func logInUserToApp(
        userID: String,
        completion: @escaping (_ success: Bool) -> ()
    ) {
        getUserInfo(forUserID: userID) { (returnedName, returnedEmail, returnedUserType, returnedDOB, returnedPhone, returnedDoctor) in
            if let name = returnedName, let email = returnedEmail, let userType = returnedUserType, let dob = returnedDOB, let phone = returnedPhone {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    UserDefaults.standard.set(name, forKey: "name")
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(userID, forKey: "user_id")
                    UserDefaults.standard.set(userType.rawValue, forKey: "user_type")
                    UserDefaults.standard.set(dob, forKey: "dob")
                    UserDefaults.standard.set(phone, forKey: "phone")
                    
                    if userType == .patient, let doctor = returnedDoctor {
                        UserDefaults.standard.set(doctor, forKey: "doctor")
                    }
                }
                print("Success getting user info while logging in")
                completion(true)
            } else {
                print("Error getting user info while logging in")
                completion(false)
            }
        }
    }

    func getUserInfo(forUserID userID: String, completion: @escaping (_ name: String?, _ email: String?, _ userType: UserTypeEnum?, _ dob: String?, _ phone: String?, _ doctor: String?) -> ()
    ) {
        REF_USERS.document(userID).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot,
               let name = document.get("name") as? String,
               let email = document.get("email") as? String,
               let userTypeRaw = document.get("type") as? String,
               let userType = UserTypeEnum(rawValue: userTypeRaw),
               let dob = document.get("dob") as? String,
               let phone = document.get("phone") as? String {
                var doctor: String? = nil
                if userType == .patient {
                    doctor = document.get("doctor") as? String
                }
                print("Success getting user info")
                completion(name, email, userType, dob, phone, doctor)
            } else {
                print("Error getting user info")
                completion(nil, nil, nil, nil, nil, nil)
            }
        }
    }

    //MARK: SIGN OUT USER
    func signOut() async throws {
        do {
            try Auth.auth().signOut()
            self.clearUserDefaults()
        } catch {
            print("Error logging out user: ", error)
        }
    }
    
    private func clearUserDefaults() {
        let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
        for key in defaultsDictionary.keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
