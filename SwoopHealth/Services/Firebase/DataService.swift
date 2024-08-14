//
//  DataService.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/3/24.
//

import SwiftUI
import Firebase

class DataService {
    
    static let shared = DataService()
    
    private init() {}
    
    private var REF_USERS = D_BASE.collection("users")
    private var REF_DOCTORS = D_BASE.collection("doctors")
    private var REF_MESSAGES = D_BASE.collection("messages")
    private var REF_EVENTS = D_BASE.collection("events")
    
    @AppStorage("user_id") var currentUserID: String?
    
    // MARK: PATIENT FUNCTIONS
    func getUsers(completion: @escaping (_ users: [UserModel]?) -> ()) {
        REF_USERS.getDocuments { (returnedSnapshot, returnedError) in
            if let error = returnedError {
                print("Error getting users from Firebase: ", error)
                completion(nil)
                return
            }
            
            guard let snapshot = returnedSnapshot else {
                print("Error unwrapping users snapshots.")
                completion(nil)
                return
            }
            
            var users: [UserModel] = []
            
            for document in snapshot.documents {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                    let user = try JSONDecoder().decode(UserModel.self, from: jsonData)
                    users.append(user)
                } catch {
                    print("Error parsing user data for document.")
                }
            }
            
            print("Success getting users: ", users)
            completion(users)
        }
    }

    // MARK: MESSAGING FUNCTIONS
    // Doctor and Nurses go to user patient collection document(their id) to see messages
    // Users see messages in their own document collection
    func getMessages(_ firstUserID: String, _ secondUserID: String, completion: @escaping (_ messages: [MessageModel]?) -> ()) {
        let messagePath = REF_MESSAGES.document(firstUserID).collection(secondUserID)

        messagePath.addSnapshotListener { (returnedSnapshot, returnedError) in
            if let error = returnedError {
                print("Error getting messages: ", error)
                completion(nil)
                return
            }
            
            guard let snapshot = returnedSnapshot?.documents else {
                completion(nil)
                return
            }
            
            var messages: [MessageModel] = []
            for document in snapshot {
                if let messageData = document.data() as? [String : Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: messageData, options: [])
                        let message = try JSONDecoder().decode(MessageModel.self, from: jsonData)
                        messages.append(message)
                    } catch {
                        print("Error decoding message: ", error)
                        completion(nil)
                        return
                    }
                }
            }

            completion(messages)
        }
    }

    func saveMessage(_ firstUserID: String, _ secondUserID: String, message: MessageModel, completion: @escaping (_ success: Bool) -> ()) {
        // Paths to the message collections for both users
        let firstUserMessagesPath = REF_MESSAGES.document(firstUserID).collection(secondUserID)
        let secondUserMessagesPath = REF_MESSAGES.document(secondUserID).collection(firstUserID)
        
        do {
            let jsonData = try JSONEncoder().encode(message)
            let messageData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            
            firstUserMessagesPath.addDocument(data: messageData ?? [:])
            secondUserMessagesPath.addDocument(data: messageData ?? [:])
            
            print("Successfully saved intial message to Firestore")
            completion(true)
        } catch {
            print("Error saving initial message to Firestore: ", error)
            completion(false)
        }
    }
    
    func getUserModel() {
        
    }
    
    // MARK: EVENT FUNCTIONS
    func saveEvent(event: EventModel, completion: @escaping (_ success: Bool) -> ()) {
        do {
            let jsonData = try JSONEncoder().encode(event)
            let messageData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            
            REF_EVENTS.addDocument(data: messageData ?? [:])
            
            print("Successfully saved intial message to Firestore")
            completion(true)
        } catch {
            print("Error saving initial message to Firestore: ", error)
            completion(false)
        }
    }
    
    func getEvents(completion: @escaping (_ events: [EventModel]?) -> ()) {
        REF_EVENTS.addSnapshotListener { (returnedSnapshot, returnedError) in
            if let error = returnedError {
                print("Error getting messages: ", error)
                completion(nil)
                return
            }
            
            guard let snapshot = returnedSnapshot?.documents else {
                completion(nil)
                return
            }
            
            var messages: [EventModel] = []
            for document in snapshot {
                if let messageData = document.data() as? [String : Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: messageData, options: [])
                        let message = try JSONDecoder().decode(EventModel.self, from: jsonData)
                        messages.append(message)
                    } catch {
                        print("Error decoding message: ", error)
                        completion(nil)
                        return
                    }
                }
            }

            completion(messages)
        }
    }
    
    func updateUserDoctor(doctorName: String, completion: @escaping (_ success: Bool) -> ()) {
        guard let userID = currentUserID else {
            print("Error unwrapping current user id.")
            completion(false)
            return
        }
        
        let userReference = REF_USERS.document(userID)
        userReference.updateData(["doctor": doctorName]) { (returnedError) in
            if let error = returnedError {
                print("Error updating doctor reference in user document. \(error)")
                completion(false)
                return
            }
            
            UserDefaults.standard.set(doctorName, forKey: "doctor")
            completion(true)
        }
    }
}
