//
//  TripInitFormView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 15/04/25.
//

import SwiftUI
import CoreLocation

let initialTrip: Trip = Trip(
    type: .passenger,
    mode: .fourWheels,
    date: Date(),
)


struct TripInitFormView: View {
    @State private var trip: Trip = initialTrip
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    @StateObject var auth = AuthViewModel()
    
    var from: Place?
    var to: Place?
    
    @EnvironmentObject var navManager: NavigationManager<HomeRoutes>
    
    func createTripAction() {
        // check if data present
        let isDriverDataValid = trip.type == .driver && !trip.vehicleType.isEmpty && !trip.seats.isEmpty && !trip.fee.isEmpty
        let isPlacePresent: Bool = from != nil && to != nil
        
        if (trip.type != .passenger && !isDriverDataValid) || !isPlacePresent {
            showAlert = true
            return
        }
        
        isLoading = true
        if let fromPlace = from, let toPlace = to {
            trip.injectLocation(from: fromPlace, to: toPlace)
        }
        if let userId = auth.user?.uid {
            trip.createTrip(userId) { result in
                isLoading = false
                switch result {
                case .success(let documentId):
                    navManager.path.append(.tripDetails(tripId: documentId))
                    print("Success")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
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
                    .font(.headline)
                Picker("Mode", selection: $trip.mode) {
                    Label("Two Wheeler", systemImage: "motorcycle.fill")
                        .tag(TravelMode.twoWheels)
                    Label("Four Wheeler", systemImage: "car.fill")
                        .tag(TravelMode.fourWheels)
                }
                .pickerStyle(.segmented)
                
                Text("Additional Note:")
                    .font(.headline)
                TextEditor(text: $trip.description)
                    .frame(height: 150)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                
                
                if(trip.type == .driver) {
                    VStack(alignment: .leading) {
                        Text("Vehicle Information")
                            .font(.headline)
                        AdditionalInput("Type", text: $trip.vehicleType)
                        AdditionalInput("Plate Number", text: $trip.plateNumber)
                        AdditionalInput("Seats Available", text: $trip.seats)
                            .keyboardType(.decimalPad)
                        AdditionalInput("Fee", text: $trip.fee)
                            .keyboardType(.decimalPad)
                    }
                }
                
                
                
                Button(action: createTripAction) {
                    Label(isLoading ? "Creating..." : "Find", systemImage: "magnifyingglass")
                        .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 16)
                .background(.main)
                .foregroundStyle(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .cornerRadius(8)
                .disabled(isLoading)
            }
        }
        .alert("Alert", isPresented: $showAlert) {
            Button("OK", role: .cancel, action: {
                self.showAlert = false
            })
        } message: {
            Text("Please complete all the required fields.")
        }
    }
}

#Preview {
    TripInitFormView()
}

struct AdditionalInput: View {
    @Binding var text: String
    var label: String
    
    init(_ label: String, text: Binding<String>) {
        self._text = text
        self.label = label
    }
    
    
    var body: some View {
        HStack {
            Text(label)
                .frame(width: 125, alignment: .leading)
            TextField(label, text: $text)
        }
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.5))
                .offset(y: 10),
            alignment: .bottom
        )
        .padding(.vertical, 5)
    }
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
