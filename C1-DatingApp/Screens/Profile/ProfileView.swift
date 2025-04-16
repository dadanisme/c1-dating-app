//
//  ProfileView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 11/04/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var auth = AuthViewModel()
    var body: some View {
        Button("Logout", action: {
            auth.signOut()
        })
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    ProfileView()
}
