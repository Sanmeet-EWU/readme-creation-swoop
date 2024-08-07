//
//  EventModel.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/4/24.
//

import Foundation

class EventModel: Identifiable, Codable {
    let id = UUID()
    var user: UserModel?
    let eventDate: Date
    let title: String
    let description: String
    
    init(user: UserModel? = nil, eventDate: Date, title: String, description: String) {
        self.user = user
        self.eventDate = eventDate
        self.title = title
        self.description = description
    }
}
