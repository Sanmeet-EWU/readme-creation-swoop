//
//  MessageModel.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/23/24.
//

import SwiftUI

struct MessageModel: Identifiable, Codable {
    let id = UUID()
    let senderID: String
    let name: String
    let content: String
    let date: Date
}
