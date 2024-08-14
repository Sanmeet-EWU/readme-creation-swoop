//
//  DoctorDetailsViewModel.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/13/24.
//

import Foundation

class DoctorDetailsViewModel: ObservableObject {
    
    @Published var successAlert: Bool = false
    
    func updateUserDoctor(doctorName: String) {
        let dataInstance = DataService.shared
        dataInstance.updateUserDoctor(doctorName: doctorName) { (success) in
            if (success) {
                self.successAlert = true
            }
        }
    }
}
