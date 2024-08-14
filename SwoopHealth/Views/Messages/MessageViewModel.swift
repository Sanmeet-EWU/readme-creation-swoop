//
//  MessageViewModel.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/4/24.
//

import SwiftUI

class MessageViewModel: ObservableObject {
    
    let secondUserID: String
    
    @Published var messages: [MessageModel] = []
    @Published var message: String = ""
    
    @AppStorage("user_id") var currentUserID: String?
    @AppStorage("name") var currentUserName: String?
    
    init(secondUserID: String) {
        self.secondUserID = secondUserID
        getMessages(secondUserID: secondUserID)
    }
    
    private func getMessages(secondUserID: String) {
        guard let userID = currentUserID else {
            return
        }
        
        let dataInstance = DataService.shared
        dataInstance.getMessages(userID, secondUserID) { (returnedMessages) in
            if let messages = returnedMessages {
                let sortedMessages = messages.sorted {
                    $0.date < $1.date
                }
                
                self.messages = sortedMessages
            }
        }
    }
    
    func sendMessage() {
        guard let userID = currentUserID else {
            print("Unable to unwrap user id.")
            return
        }
        
        let dataInstance = DataService.shared
        
        let message = MessageModel(
            senderID: userID,
            name: currentUserName ?? "",
            content: message,
            date: Date()
        )
        
        dataInstance.saveMessage(userID, secondUserID, message: message) { (success) in
            if (success) {
                self.message = ""
                print("Success saving message in Firebase.")
            }
        }
    }
}
