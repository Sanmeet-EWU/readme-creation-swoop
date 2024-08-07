//
//  CalendarView.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/14/24.
//

import SwiftUI

struct CalendarView: View {
    
    
    @State var showCreateEventSheet: Bool = false
    
    @StateObject var viewModel = CalendarViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                
                Text(dateFormatter.string(from: viewModel.selectedDate))
                    .font(.system(size: 16))
                    .padding(.vertical, 15)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.events) { event in
                            Event(event: event)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                showCreateEventSheet.toggle()
            } label: {
                ZStack {
                    Circle()
                        .foregroundStyle(.ultraThinMaterial)
                        .frame(width: 58, height: 58)
                    Image(systemName: "plus")
                        .font(.system(size: 28))
                        .foregroundStyle(Color.theme.blue)
                }
            }
            .buttonStyle(ButtonScaleEffectStyle())
            .sheet(isPresented: $showCreateEventSheet) {
                CreateEventSheet(viewModel: viewModel)
            }
            .padding()
        }
    }
}

#Preview {
    CalendarView()
}
