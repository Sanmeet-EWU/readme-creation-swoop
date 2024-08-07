//
//  UserModel.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/3/24.
//

import SwiftUI

struct UserModel: Identifiable, Codable {
    var id: String
    let name: String
    let dob: String
    let email: String
    let phone: String
    let type: UserTypeEnum
    let doctor: String?
}

