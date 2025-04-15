//
//  MainTabView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 11/04/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            
            Tab("My Trips", systemImage: "list.bullet.rectangle.portrait.fill") {
                Text("Not implemented yet")
            }
            
            Tab("Profile", systemImage: "person") {
                ProfileView()
            }
        }
        .tint(.main)
    }
}


#Preview {
    MainTabView()
}
