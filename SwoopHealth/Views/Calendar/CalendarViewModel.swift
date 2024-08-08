//
//  CalendarViewModel.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/4/24.
//

import Foundation

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
    
    init() {
        getEvents()
        getPatients()
    }
    
    func getPatients() {
        let dataInstance = DataService.shared
        
        dataInstance.getPatients { (returnedPatients) in
            if let patients = returnedPatients {
                self.patients = patients
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
        
        return events.filter {
            startOfDay(for: $0.eventDate) == selectedDateStartOfDay
        }
    }
    
    func limitTitleText(_ text: String, limit: Int) -> String {
        return String(text.prefix(limit))
    }
    
    func limitDescriptionText(_ text: String, limit: Int) -> String {
        return String(text.prefix(limit))
    }
}
