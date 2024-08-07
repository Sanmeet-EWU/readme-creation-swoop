//
//  EventSheet.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/6/24.
//

import SwiftUI
import MapKit

struct EventSheet: View {
    
    let event: EventModel
    
    @State var sheetContentHeight = CGFloat(0)
    
    @State var coordinates = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 47.651667, longitude: -117.423611), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
    
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
        VStack(spacing: 16) {
            Capsule()
                .frame(width: 45, height: 5)
                .foregroundStyle(Color(.systemGray4))
                .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Circle()
                        .foregroundStyle(Color.theme.darkBlue)
                        .frame(width: 28, height: 28)
                        .overlay {
                            if let name = event.user?.name {
                                Text(String(name.first!))
                                    .foregroundStyle(.white)
                                    .font(.system(size: 15, weight: .medium))
                            }
                        }
                    
                    if let name = event.user?.name {
                        Text(name)
                            .font(.system(size: 17, weight: .medium))
                    }
                    Spacer()
                }
                
                Rectangle()
                    .frame(height: 1)
                    .padding(.vertical, 8)
                    .foregroundStyle(Color(.systemGray4))
                
                HStack {
                    Text(event.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer(minLength: 0)
                }
                Text(event.description)
                    .font(.system(size: 16))
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color(.systemGray6))
            }
            
            dates
            
            Map(coordinateRegion: $coordinates)
                .frame(height: 200)
                .cornerRadius(16)
                .padding(.bottom)
        }
        .padding([.horizontal, .bottom])
        .fixedSize(
            horizontal: false,
            vertical: true
        )
        .background {
            GeometryReader { proxy in
                Color.clear.task {
                    sheetContentHeight = proxy.size.height
                }
            }
        }
        .presentationDetents([.height(sheetContentHeight)])
    }
}

#Preview {
    EventSheet(event: EventModel(
        user: nil,
        eventDate: Date(),
        title: "",
        description: ""
    )
    )
}

extension EventSheet {
    private var dates: some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 20))
                Text(dateFormatter.string(from: event.eventDate))
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.white)
            
            Spacer()
            
            HStack(spacing: 8) {
                Image(systemName: "clock")
                    .font(.system(size: 20))
                Text(timeFormatter.string(from: event.eventDate))
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.white)
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.theme.darkBlue)
        }
    }
}
