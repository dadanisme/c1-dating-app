//
//  UserModel.swift
//  C1-DatingApp
//
//  Created by Ramdan on 21/04/25.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let displayName: String
    let email: String
    let photoURL: String?
    let isVerified: Bool?
}
