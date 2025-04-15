//
//  TripInitResultItemView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 15/04/25.
//

import SwiftUI

struct TripInitResultItemView: View {
    var item: Place
    
    init(_ item: Place) {
        self.item = item
    }


    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(item.name)
                        .font(.headline)
                    Spacer()
                    
                    let distanceInKilometers = (item.distance ?? 0) / 1000
                    let formattedDistance = String(format: "%.1f km", distanceInKilometers)
                    
                    Text("~\(formattedDistance)")
                        .font(.caption)
                }
                Text(item.subtitle)
                    .font(.caption)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 4)
        }
    }
}
