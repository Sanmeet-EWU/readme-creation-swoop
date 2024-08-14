//
//  UserModel.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/3/24.
//

import SwiftUI

struct UserModel: Identifiable, Codable, Equatable {
    var id: String
    let name: String
    let dob: String
    let email: String
    let phone: String
    let type: UserTypeEnum
    let doctor: String?
    
    static func ==(lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.dob == rhs.dob &&
        lhs.email == rhs.email &&
        lhs.phone == rhs.phone &&
        lhs.type == rhs.type &&
        lhs.doctor == rhs.doctor
    }
}

