//
//  GreetingView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 11/04/25.
//

import SwiftUI

struct GreetingView: View {
    @StateObject private var auth = AuthViewModel()
    var body: some View {
        VStack {
            VStack {
                Text("Welcome, \(auth.user?.displayName ?? "User")!")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .fontWeight(.bold)
                NavigationLink {
                    Text("To be implemented")
                } label: {
                    HStack {
                        Text("Where do you want to go?")
                            .foregroundColor(.gray)

                        Spacer()
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                HStack(spacing: 16) {
                    InfoCardView(icon: "figure.wave", number: 200, title: "Looking for a ride")
                    InfoCardView(icon: "figure.2", number: 100, title: "Looking for partners")
                }
                .offset(x:0, y: 20)
                .padding(.horizontal)
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .padding(.init(top: 50, leading: 10, bottom: 0, trailing: 10))
        }
        .background(.main)
    }
}

#Preview {
    GreetingView()
}
