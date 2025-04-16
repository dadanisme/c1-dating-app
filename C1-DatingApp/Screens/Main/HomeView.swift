//
//  Home.swift
//  C1-DatingApp
//
//  Created by Ramdan on 10/04/25.
//

import SwiftUI

enum HomeRoutes: Hashable {
    case tripInit
    case tripDetails(tripId: String)
}

struct HomeView: View {
    @StateObject var auth = AuthViewModel()
    @StateObject var navigationManager = NavigationManager<HomeRoutes>()
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                GreetingView()
                NearbyTripsView()
                Spacer() // just in case there is not enough nearby trips to fill the height
            }
            .navigationDestination(for: HomeRoutes.self) { route in
                switch route {
                    case .tripInit:
                        TripInitView()
                    case .tripDetails(let id):
                        Text("Trip Details \(id)")
                }
            }
        }
        .environmentObject(navigationManager)
    }
}

#Preview {
    HomeView()
}
