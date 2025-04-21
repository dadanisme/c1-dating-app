//
//  NearbyTripsView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 11/04/25.
//

import SwiftUI
import CoreLocation

struct NearbyTripsView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var nearbyTrips = NearbyTrip()
    @State private var hasFetched = false
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Nearby Trips")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                Spacer()
            }
            .padding(.top, 60)
            .padding(.horizontal)
            
            if nearbyTrips.isLoading {
                ProgressView()
                    .padding()
            } else {
                NearbyTripsList(trips: nearbyTrips.trips)
                    .refreshable {
                        if let location = locationManager.location {
                            Task {
                                await nearbyTrips.fetchData(userLocation: location)
                            }
                        }
                    }
            }
        }
        .task(id: locationManager.location, {
            if let location = locationManager.location {
                if hasFetched { return } else {
                    Task {
                        await nearbyTrips.fetchData(userLocation: location)
                        hasFetched = true
                    }
                }
            }
        })
    }
}

#Preview {
    NearbyTripsView()
}

struct NearbyTripsList: View {
    var trips: [Trip]
    @EnvironmentObject var navManager: NavigationManager<HomeRoutes>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(trips.enumerated()), id: \.element.id) { index, trip in
                    Button(action: {
                        navManager.path.append(.tripDetails(tripId: trip.id!))
                    }) {
                        NearbyTripView(trip: trip, noTopPadding: index == 0, noBottomPadding: index == trips.count - 1)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}
