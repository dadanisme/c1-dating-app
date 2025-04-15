//
//  NearbyTripsView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 11/04/25.
//

import SwiftUI

struct NearbyTripsView: View {
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
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(dummyTrips.enumerated()), id: \.element.id) { index, trip in
                        NavigationLink(destination: Text("Something")) {
                            NearbyTripView(trip: trip, noTopPadding: index == 0, noBottomPadding: index == dummyTrips.count - 1)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

#Preview {
    NearbyTripsView()
}
