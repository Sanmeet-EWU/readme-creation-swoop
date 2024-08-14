//
//  PatientsViewModel.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/3/24.
//

import SwiftUI

class PatientsViewModel: ObservableObject {
    
    enum SortOption {
        case name
        case type
    }
    
    @Published var search: String = ""
    @Published var patients: [UserModel] = []
    @Published var sortOption: SortOption = .name
    @Published var favoritePatients: Set<String> = []
    
    @AppStorage("user_type") var currentUserType: String?
    
    private let allFavoritesKey = "all_favorites_key"
    
    var filteredPatients: [UserModel] {
        if search.isEmpty {
            return filterWithoutSearch(
                patients,
                currentUserType
            )
        } else {
            return filterWithSearch(
                patients,
                currentUserType,
                search
            )
        }
    }
    
    var sortedPatients: [UserModel] {
        switch sortOption {
        case .name:
            return filteredPatients.sorted {
                $0.name.lowercased() < $1.name.lowercased()
            }
        case .type:
            return filteredPatients.sorted {
                $0.type.rawValue < $1.type.rawValue
            }
        }
    }
    
    var favoriteFilteredPatients: [UserModel] {
        return filteredPatients.filter {
            favoritePatients.contains($0.id)
        }
    }
    
    init() {
        getPatients()
        loadFavorites()
    }
    
    private func getPatients() {
        let dataInstance = DataService.shared
        dataInstance.getUsers { (returnedUsers) in
            if let users = returnedUsers {
                self.patients = users
            }
        }
    }
    
    private func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.array(forKey: allFavoritesKey) as? [String] {
            favoritePatients = Set(savedFavorites)
        }
    }
    
    func toggleFavorite(patient: UserModel) {
        if favoritePatients.contains(patient.id) {
            favoritePatients.remove(patient.id)
        } else {
            favoritePatients.insert(patient.id)
        }
         saveFavorites() // Save favorites after toggling
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoritePatients), forKey: allFavoritesKey)
    }

    // Current user type can be "patient", "admin", "nurse", "doctor"
    func filterWithoutSearch(_ patients: [UserModel], _ currentUserType: String?) -> [UserModel] {
        guard let userType = currentUserType else {
            print("Unable to unwrap current user type.")
            return []
        }
        
        return patients.filter {
            if userType == "patient" {
                return $0.type.rawValue == "doctor" ||
                       $0.type.rawValue == "nurse" ||
                       $0.type.rawValue == "admin"
            } else {
                return true
            }
        }
    }

    // Current user type can be "patient", "admin", "nurse", "doctor"
    func filterWithSearch(_ patients: [UserModel], _ currentUserType: String?, _ search: String) -> [UserModel] {
        guard let userType = currentUserType else {
            print("Unable to unwrap current user type.")
            return []
        }
        
        return patients.filter {
            if userType == "patient" {
                return ($0.type.rawValue == "doctor" ||
                        $0.type.rawValue == "nurse" ||
                        $0.type.rawValue == "admin") &&
                ($0.name.lowercased().contains(search.lowercased()) ||
                 $0.email.lowercased().contains(search.lowercased()))
            } else {
                return $0.name.lowercased().contains(search.lowercased()) ||
                $0.email.lowercased().contains(search.lowercased())
            }
        }
    }
}
