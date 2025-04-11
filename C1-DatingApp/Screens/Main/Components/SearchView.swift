//
//  SearchView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 11/04/25.
//


import SwiftUI

struct SearchView: View {
    @State var text: String = ""

    var body: some View {
        HStack {
            TextField("Where do you want to go?", text: $text)
                .foregroundColor(.primary)
            Image(systemName: "magnifyingglass") // 🔍 icon
                .foregroundColor(.gray)
        }
        .padding(10)
        .background(Color(.systemGray6)) // light gray background
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    SearchView()
}
