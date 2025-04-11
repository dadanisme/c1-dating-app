//
//  NearbyTripView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 11/04/25.
//

import SwiftUI

struct NearbyTripView: View {
    var trip: NearbyTripModel
    var noTopPadding: Bool = false
    var noBottomPadding: Bool = false
    
    var body: some View {
        Section {
            HStack(alignment: .center, spacing: 12) {
                Image("jensen_huang_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(5)
                
                VStack (alignment: .leading) {
                    HStack {
                        Text("Jensen Huang")
                            .fontWeight(.semibold)
                        Image(systemName: "checkmark.shield.fill")
                            .foregroundStyle(.main)
                    }
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.red)
                        Text("Uluwatu Temple")
                            .font(.caption)
                    }
                    Text("Thu, 21 Jan 2025, 13.00 WITA")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("Rp15.000")
                        .font(.subheadline)
                    NavigationLink {
                        Text("Something")
                    } label: {
                        Button("Details", action: {
                            //
                        })
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(.main)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .allowsHitTesting(false)
                    }
                }
            }
            .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 10))
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) // remove default inset
            .frame(maxWidth: .infinity)

        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1) // Thin grey border
        )
        .listSectionSpacing(8)
        .padding(.horizontal)
        .padding(.top, noTopPadding ? 0 : 4)
        .padding(.bottom, noBottomPadding ? 0 : 4)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    NearbyTripView(
        trip: NearbyTripModel(
            imageName: "jensen_huang_1", name: "Jensen Huang", location: "Park23 City", time: "Thu, 21 Jan 2025, 13.00 WITA", price: 15000
        )
    )
}
