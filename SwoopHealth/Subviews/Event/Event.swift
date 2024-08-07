//
//  Event.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/6/24.
//

import SwiftUI

struct Event: View {
    let event: EventModel
    
    @State var showEventSheet: Bool = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    var body: some View {
        Button {
            showEventSheet.toggle()
        } label: {
            content
        }
        .buttonStyle(ButtonScaleEffectStyle())
        .sheet(isPresented: $showEventSheet) {
            EventSheet(event: event)
        }
    }
}

#Preview {
    Event(event: EventModel(
        user: nil,
        eventDate: Date(),
        title: "",
        description: "")
    )
}

extension Event {
    private var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                HStack(alignment: .center, spacing: 10) {
                    if let name = event.user?.name {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white)
                            .overlay {
                                Text(String(name.first!))
                                    .font(.system(size: 22, weight: .medium))
                                    .foregroundStyle(Color.theme.darkBlue)
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(name)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.white)
                            
                            Text(event.title)
                                .font(.system(size: 15))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                Image(systemName: "phone.circle.fill")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(Color.theme.darkBlue)
                    .background {
                        Circle()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.white)
                    }
            }
            
            HStack(spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.system(size: 18))
                    Text(dateFormatter.string(from: event.eventDate))
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white)
                
                Text("|")
                    .foregroundStyle(.white)
                
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .font(.system(size: 18))
                    Text(timeFormatter.string(from: event.eventDate))
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white)
            }
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.theme.darkBlue)
            }
            .padding(.top)
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.theme.blue)
        }
    }
}
