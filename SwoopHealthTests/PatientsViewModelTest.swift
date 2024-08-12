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
        //pulled from Katrina's discord message 8/9/24 JM
        viewModel.currentUserType = "patient"
        viewModel.patients = patients
        viewModel.search = "Alice"

        let filtered = viewModel.filteredPatients

        XCTAssertEqual(filtered.count, 0, "Filtered patients with search test returned a user that doesn't match the specified filter.")   
    }

    func testFilteredPatientsWithNameSearch() throws {
        viewModel.currentUserType = "patient"
        viewModel.patients = patients
        viewModel.search = "Bob Johnson"

        let filtered = viewModel.filteredPatients

        XCTAssertEqual(filtered.count, 1, "Filtered patients with name search test did not return the correct filtered patient count.") 
        XCTAssertEqual(filtered.name, "Bob Johnson" , "Filtered patients with name search test did not return the test patient name "Bob Johnson".") 

    }
    
    
    func testSortedPatientsByName() throws {
        viewModel.currentUserType = "patient"
        viewModel.patients = patients
        viewModel.order(by: "name", descending: true)

        let sorted = viewModel.sortedPatients
        // check use of built in sorted() correct for assert statement
        XCTAssertTrue(sorted, patients.sorted(), "Sorted patients by name should return patients in alphabetical order.")
    }
    
    func testSortedPatientsByType() throws {
        viewModel.currentUserType = "patient"
        viewModel.patients = patients
        viewModel.order(by: "type",)

        let sorted = viewModel.sortedPatients
        XCTAssertTrue(sorted.allSatisfy { $0.type != .patient }, "Sorted patients by type patient should not include non-patient users.")  
    }
    
    func testFavoriteFilteredPatients() throws {
        viewModel.currentUserType = "patient"
        viewModel.patients = patients
        viewModel.filter { $0. isFavorite }

        let favPatients = viewModel.filteredPatients

        XCTAssertTrue(favPatients.allSatisfy {$0 isFavorite == true}, "Filtered favorite patients test should return favorite patients only." )
    }
}

