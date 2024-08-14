//
//  CalendarViewModel.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/4/24.
//

import SwiftUI

class CalendarViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var description: String = ""
    
    @Published var selectedPatient: UserModel? = nil
    
    @Published var success: Bool = false
    @Published var isLoading: Bool = false
    
    @Published var events: [EventModel] = []
    @Published var patients: [UserModel] = []
    
    // When selectedDate changes, new events are filtered.
    @Published var selectedDate: Date = Date() {
        didSet {
            getEvents()
        }
    }
    
    @AppStorage("user_type") var currentUserType: String?
    @AppStorage("user_id") var currentUserID: String?
    
    init() {
        getEvents()
        getPatients()
    }
    
    func getPatients() {
        let dataInstance = DataService.shared
        
        dataInstance.getUsers { (returnedUsers) in
            if let users = returnedUsers {
                self.patients = users
            }
        }
    }
    
    func saveEvent() {
        isLoading = true
        guard let patient = selectedPatient else {
            return
        }
        
        guard title.count > 0 else {
            isLoading = false
            return
        }
    
        guard description.count > 0 else {
            isLoading = false
            return
        }
        
        let dataInstance = DataService.shared
        
        let event = EventModel(
            user: patient,
            eventDate: selectedDate,
            title: title,
            description: description
        )
        
        dataInstance.saveEvent(event: event) { (success) in
            if (success) {
                self.isLoading = false
                self.success = true
                print("Success saving event to Firebase.")
            } else {
                self.isLoading = false
                print("Error saving event to Firebase.")
            }
        }
    }
    
    func getEvents() {
        let dataInstance = DataService.shared
        
        dataInstance.getEvents { (returnedEvents) in
            if let events = returnedEvents {
                self.events = self.filterEvents(events)
            } else {
                print("Error getting events from Firebase.")
            }
        }
    }
    
    func filterEvents(_ events: [EventModel]) -> [EventModel] {
        func startOfDay(for date: Date) -> Date {
            let calendar = Calendar.current
            return calendar.startOfDay(for: date)
        }

        let selectedDateStartOfDay = startOfDay(for: selectedDate)
        let filterByType = filterByAccountType(events)
        
        return filterByType.filter {
            startOfDay(for: $0.eventDate) == selectedDateStartOfDay
        }
    }
    
    private func filterByAccountType(_ events: [EventModel]) -> [EventModel] {
        guard let userType = currentUserType else {
            print("Error unwrapping current user type.")
            return events
        }
        
        guard let userID = currentUserID else {
            print("Error unwrapping current user id.")
            return events
        }
        
        if (userType == "patient") {
            return events.filter { event in
                event.user?.id == userID
            }
        } else {
            return events
        }
    }
    
    func limitTitleText(_ text: String, limit: Int) -> String {
        return String(text.prefix(limit))
    }
    
    func limitDescriptionText(_ text: String, limit: Int) -> String {
        return String(text.prefix(limit))
    }
}
