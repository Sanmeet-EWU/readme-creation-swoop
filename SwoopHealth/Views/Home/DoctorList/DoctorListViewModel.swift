//
//  DoctorListViewModel.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/12/24.
//

import SwiftUI

class DoctorListViewModel: ObservableObject {
    
    enum SortOption {
        case name
        case type
    }
    
    @Published var search: String = ""
    @Published var doctors: [UserModel] = []
    @Published var sortOption: SortOption = .name
    @Published var favoriteDoctors: Set<String> = []
    
    @AppStorage("user_type") var currentUserType: String?
    
    private let doctorsFavoritesKey = "doctors_favorites_key"
    
    var filteredDoctors: [UserModel] {
        if search.isEmpty {
            return filterWithoutSearch(
                doctors,
                currentUserType
            )
        } else {
            return filterWithSearch(
                doctors,
                currentUserType,
                search
            )
        }
    }
    
    var sortedDoctors: [UserModel] {
        switch sortOption {
        case .name:
            return filteredDoctors.sorted {
                $0.name.lowercased() < $1.name.lowercased()
            }
        case .type:
            return filteredDoctors.sorted {
                $0.type.rawValue < $1.type.rawValue
            }
        }
    }
    
    var favoriteFilteredDoctors: [UserModel] {
        return filteredDoctors.filter {
            favoriteDoctors.contains($0.id)
        }
    }
    
    init() {
        getDoctors()
        loadFavorites()
    }
    
    private func getDoctors() {
        let dataInstance = DataService.shared
        dataInstance.getUsers { (returnedUsers) in
            if let users = returnedUsers {
                self.doctors = users
            }
        }
    }
    
    private func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.array(forKey: doctorsFavoritesKey) as? [String] {
            favoriteDoctors = Set(savedFavorites)
        }
    }
    
    func toggleFavorite(doctor: UserModel) {
        if favoriteDoctors.contains(doctor.id) {
            favoriteDoctors.remove(doctor.id)
        } else {
            favoriteDoctors.insert(doctor.id)
        }
         saveFavorites()
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteDoctors), forKey: doctorsFavoritesKey)
    }

    // Current user type can be "patient", "admin", "nurse", "doctor"
    func filterWithoutSearch(_ doctors: [UserModel], _ currentUserType: String?) -> [UserModel] {
        guard let userType = currentUserType else {
            print("Unable to unwrap current user type.")
            return []
        }
        
        return doctors.filter {
            if userType == "patient" {
                return $0.type.rawValue == "doctor"
            } else {
                return false
            }
        }
    }

    // Current user type can be "patient", "admin", "nurse", "doctor"
    func filterWithSearch(_ doctors: [UserModel], _ currentUserType: String?, _ search: String) -> [UserModel] {
        guard let userType = currentUserType else {
            print("Unable to unwrap current user type.")
            return []
        }
        
        return doctors.filter {
            if userType == "patient" {
                return ($0.type.rawValue == "doctor") &&
                ($0.name.lowercased().contains(search.lowercased()) ||
                 $0.email.lowercased().contains(search.lowercased()))
            } else {
                return $0.name.lowercased().contains(search.lowercased()) ||
                $0.email.lowercased().contains(search.lowercased())
            }
        }
    }
}
