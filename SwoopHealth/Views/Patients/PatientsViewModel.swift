//
//  PatientsViewModel.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/3/24.
//

import Foundation

class PatientsViewModel: ObservableObject {
    
    @Published var patients: [UserModel] = []
    
    init() {
        getPatients()
    }
    
    private func getPatients() {
        let dataInstance = DataService.shared
        dataInstance.getPatients { (returnedPatients) in
            if let patients = returnedPatients {
                self.patients = patients
            }
        }
    }
}
