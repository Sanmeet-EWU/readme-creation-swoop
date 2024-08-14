//
//  PatientsViewModelTest.swift
//  SwoopHealthTests
//
//  Created by Jacob Lucas on 8/8/24.
//

import XCTest
@testable import SwoopHealth

final class PatientsViewModelTest: XCTestCase {
    
    var viewModel: PatientsViewModel!
    
    // mockup users
    let patients = [
        UserModel(id: "1", name: "John Doe", dob: "01-01-1980", email: "john@example.com", phone: "123-456-7890", type: .doctor, doctor: nil),
        UserModel(id: "2", name: "Jane Smith", dob: "02-02-1985", email: "jane@example.com", phone: "234-567-8901", type: .nurse, doctor: nil),
        UserModel(id: "3", name: "Alice Brown", dob: "03-03-1990", email: "alice@example.com", phone: "345-678-9012", type: .admin, doctor: nil),
        UserModel(id: "4", name: "Bob Johnson", dob: "04-04-1995", email: "bob@example.com", phone: "456-789-0123", type: .patient, doctor: nil)
    ]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = PatientsViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func testFilteredPatientsWithoutSearch() throws {
        viewModel.currentUserType = "patient"
        viewModel.patients = patients
        
        let filtered = viewModel.filteredPatients
        
        XCTAssertEqual(filtered.count, 3, "Filtered patients should exclude other patients when currentUserType is 'patient'.")
        XCTAssertTrue(filtered.allSatisfy { $0.type != .patient }, "Filtered patients should not include non-patient users.")
    }
    
    func testFilteredPatientsWithSearch() throws {
        viewModel.currentUserType = "patient"
        viewModel.patients = [
            UserModel(id: "1", name: "Bob Johnson", dob: "01/01/1980", email: "bob@example.com", phone: "1234567890", type: .doctor, doctor: nil),
            UserModel(id: "2", name: "Alice Smith", dob: "02/02/1990", email: "alice@example.com", phone: "0987654321", type: .nurse, doctor: nil)
        ]
        viewModel.search = "Bob Johnson"

        let filtered = viewModel.filteredPatients

        XCTAssertEqual(filtered.count, 1, "Filtered patients with search test did not return the correct filtered patient count.")
        XCTAssertEqual(filtered.first?.name, "Bob Johnson", "Filtered patients with search test did not return the correct patient name.")
    }

    func testFilteredPatientsWithNameSearch() throws {
        viewModel.currentUserType = "patient"
        viewModel.patients = [
            UserModel(id: "1", name: "Bob Johnson", dob: "01/01/1980", email: "bob@example.com", phone: "1234567890", type: .doctor, doctor: nil),
            UserModel(id: "2", name: "Alice Smith", dob: "02/02/1990", email: "alice@example.com", phone: "0987654321", type: .nurse, doctor: nil)
        ]
        viewModel.search = "Bob Johnson"

        let filtered = viewModel.filteredPatients

        XCTAssertEqual(filtered.count, 1, "Filtered patients with name search test did not return the correct filtered patient count.")
        XCTAssertEqual(filtered.first?.name, "Bob Johnson", "Filtered patients with name search test did not return the correct patient name 'Bob Johnson'.")
    }
    
    func testSortedPatientsByName() throws {
        viewModel.currentUserType = "patient"
        viewModel.patients = [
            UserModel(id: "1", name: "Charlie Brown", dob: "01/01/1980", email: "charlie@example.com", phone: "1234567890", type: .doctor, doctor: nil),
            UserModel(id: "2", name: "Bob Johnson", dob: "02/02/1990", email: "bob@example.com", phone: "0987654321", type: .nurse, doctor: nil),
            UserModel(id: "3", name: "Alice Smith", dob: "03/03/2000", email: "alice@example.com", phone: "1122334455", type: .admin, doctor: nil)
        ]
        viewModel.sortOption = .name

        let sorted = viewModel.sortedPatients
        let expected = viewModel.patients.sorted { $0.name.lowercased() < $1.name.lowercased() }

        XCTAssertEqual(sorted.map { $0.id }, expected.map { $0.id }, "Sorted patients by name should return patients in alphabetical order.")
    }
    
    func testSortedPatientsByType() throws {
        viewModel.currentUserType = "patient"
        viewModel.patients = [
            UserModel(id: "1", name: "Charlie Brown", dob: "01/01/1980", email: "charlie@example.com", phone: "1234567890", type: .doctor, doctor: nil),
            UserModel(id: "2", name: "Bob Johnson", dob: "02/02/1990", email: "bob@example.com", phone: "0987654321", type: .nurse, doctor: nil),
            UserModel(id: "3", name: "Alice Smith", dob: "03/03/2000", email: "alice@example.com", phone: "1122334455", type: .admin, doctor: nil)
        ]
        viewModel.sortOption = .type

        let sorted = viewModel.sortedPatients
        let expected = viewModel.patients.sorted { $0.type.rawValue < $1.type.rawValue }

        XCTAssertEqual(sorted.map { $0.id }, expected.map { $0.id }, "Sorted patients by type should return patients sorted by type.")
    }
    
    func testFavoriteFilteredPatients() throws {
        viewModel.currentUserType = "patient"
        viewModel.patients = patients
        viewModel.favoritePatients = Set(patients.map { $0.id })

        let favPatients = viewModel.favoriteFilteredPatients
        XCTAssertTrue(favPatients.allSatisfy { viewModel.favoritePatients.contains($0.id) }, "Filtered favorite patients test should return favorite patients only.")
    }
}

