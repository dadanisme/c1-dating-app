//
//  Home.swift
//  C1-DatingApp
//
//  Created by Ramdan on 10/04/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var auth = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            GreetingView()
            NearbyTripsView()
            Spacer() // just in case there is not enough nearby trips to fill the height
        }
    }
}

#Preview {
    HomeView()
}
