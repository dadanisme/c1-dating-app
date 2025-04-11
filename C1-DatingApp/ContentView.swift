//
//  ContentView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 09/04/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var auth = AuthViewModel()
    
    var body: some View {
        if(auth.user != nil) {
            MainTabView()
                .environmentObject(auth)
        } else {
            LoginView()
                .environmentObject(auth)
        }
    }
}

#Preview {
    ContentView()
}
