//
//  CalendarViewModelTests.swift
//  SwoopHealthTests
//
//  Created by Jacob Lucas on 8/8/24.
//

import XCTest
@testable import SwoopHealth

final class CalendarViewModelTests: XCTestCase {
    
    var viewModel: CalendarViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = CalendarViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testFilterEvents() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let selectedDate = dateFormatter.date(from: "2024-08-08")!
        viewModel.selectedDate = selectedDate
        
        let events = [
            EventModel(user: nil, eventDate: selectedDate, title: "Event 1", description: "Description 1"),
            EventModel(user: nil, eventDate: dateFormatter.date(from: "2024-08-09")!, title: "Event 2", description: "Description 2")
        ]
        
        let filteredEvents = viewModel.filterEvents(events)
        
        XCTAssertEqual(filteredEvents.count, 1, "Only events on the selected date should be included.")
        XCTAssertEqual(filteredEvents.first?.title, "Event 1", "The event on the selected date should be included in the filtered list.")
    }
    
    func testLimitTitleText() throws {
        let input = "Radiology Appointment"
        let limit = -1
        
        let actual = viewModel.limitTitleText(input, limit: limit)
        
        XCTAssertNil(actual, "limitTitleText does not return nil given an out-of-bounds limit")
    }

    func testLimitDescriptionText() throws {
        let input = "Take X-rays of the patient"
        let limit = -1
        
        let actual = viewModel.limitDescriptionText(input, limit: limit)
        
        XCTAssertNil(actual, "limitDescriptionText does not return nil given an out-of-bounds limit")
    }
}
