//
//  InitTripSearchView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 12/04/25.
//

import SwiftUI
import CoreLocation

struct TripInitSearchView: View {
    @Binding var fromAddress: String
    @Binding var toAddress: String
    @Binding var fromPlace: Place?
    @Binding var toPlace: Place?
    var fromSearchFunction: (_ from: CLLocation?) -> Void
    var toSearchFunction: (_ from: CLLocation?) -> Void
    @FocusState.Binding var focusedField: FieldFocus?
    @StateObject var locationManager = LocationManager()
    
    func swapAddress() {
        (fromAddress, toAddress) = (toAddress, fromAddress)
        (fromPlace, toPlace) = (toPlace, fromPlace)
    }
     
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: swapAddress) {
                        Image(systemName: "arrow.up.arrow.down")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                    VStack {
                        SearchView(
                            text: $fromAddress,
                            icon: "arrow.up",
                            iconColor: .main,
                            placeholder: "My Location",
                        )
                        .focused($focusedField, equals: .from)
                        .onChange(of: fromAddress, {
                            fromSearchFunction(locationManager.location)
                        })
                        SearchView(
                            text: $toAddress,
                            icon:"mappin.and.ellipse",
                            iconColor: .red
                        )
                        .focused($focusedField, equals: .to)
                        .onChange(of: toAddress, {
                            let startPoint: CLLocation? = {
                                if let fromPlace = self.fromPlace {
                                    return CLLocation(latitude: fromPlace.latitude, longitude: fromPlace.longitude)
                                } else {
                                    return nil
                                }
                            }()
                            
                            toSearchFunction(startPoint)
                        })
                    }
                }
                .padding(.leading)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom)
        }
        .background(.main)
        
    }
}
