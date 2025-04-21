//
//  Auth.swift
//  C1-DatingApp
//
//  Created by Ramdan on 10/04/25.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: FirebaseAuth.User?
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            DispatchQueue.main.async {
                self?.user = user
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("❌ Error signing out: \(error.localizedDescription)")
        }
    }
}
