//
//  TripInitFormView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 15/04/25.
//

import SwiftUI


let initialTrip: Trip = Trip(
    type: .passenger,
    mode: .fourWheels,
    date: Date(),
)


struct TripInitFormView: View {
    @State private var trip: Trip = initialTrip
    @EnvironmentObject var navManager: NavigationManager<HomeRoutes>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Button(action: { trip.type = .passenger }) {
                    TravelTypeView(
                        text: "I am looking for a ride",
                        icon: "figure.wave",
                        isActive: trip.type == .passenger,
                        width: 24
                    )
                }
                Button(action: { trip.type = .driver }) {
                    TravelTypeView(
                        text: "I am looking for passengers",
                        icon: "figure.2",
                        isActive: trip.type == .driver,
                        width: 60
                    )
                }
            }
            DatePicker("Prefered Time", selection: $trip.date)
                .datePickerStyle(.compact)
            Picker("Mode", selection: $trip.mode) {
                Label("Two Wheeler", systemImage: "motorcycle.fill")
                    .tag(TravelMode.twoWheels)
                Label("Four Wheeler", systemImage: "car.fill")
                    .tag(TravelMode.fourWheels)
            }
            .pickerStyle(.segmented)
            
            Text("Additional Note:")
            TextEditor(text: $trip.description)
                .frame(height: 150)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            Button("Find", systemImage: "magnifyingglass") {
                navManager.path.append(.tripDetails(tripId: trip.id.hashValue.description))
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(.main)
            .foregroundStyle(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(8)
        }
    }
}

#Preview {
    TripInitFormView()
}

struct TravelTypeView: View {
    var text: String
    var icon: String
    var isActive: Bool = false
    var width: CGFloat?
    var height: CGFloat?

    var body: some View {
        VStack {
            VStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: width ?? 48, height: height ?? 48)
                    .foregroundStyle(isActive ? .white : .main)
                Text(text)
                    .foregroundStyle(isActive ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .font(.callout)
            }
            .padding()
        }
        .padding()
        .background(isActive ? .main : .white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 4)
        .frame(maxWidth: .infinity)
    }
}
