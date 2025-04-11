//
//  InfoCardView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 11/04/25.
//

import SwiftUI

struct InfoCardView: View {
    var icon: String
    var number: Int
    var title: String

    var body: some View {
        VStack(spacing: 8) {
            VStack {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(.main)
                    Text("\(number)")
                        .font(.system(size: 36, weight: .heavy))
                        .foregroundColor(.main)
                }
                Text(title)
                    .font(.caption)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical)


        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 4)
    }
}

#Preview {
    InfoCardView(
        icon: "swirl.circle.righthalf.filled",
        number: 200,
        title: "Lorem Ipsum"
    )
}
