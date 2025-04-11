//
//  RegisterView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 10/04/25.
//

import SwiftUI

struct RegisterView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var name: String = ""
    @State private var showAlert: Bool = false
    
    func signUp() {
        showAlert = true
    }
    
    var body: some View {
        VStack {
            Text("Register Page")
                .font(.largeTitle)
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            Button(action: signUp) {
                Text("Register")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
        }
        .padding()
        .alert("Not Implemented 😅", isPresented: $showAlert) {
            Button("OK", role: .cancel, action: {
                self.showAlert = false
            })
        } message: {
            Text("I'm sorry, I didn't plan to implement this. Use Google login instead")
        }
    }
}


#Preview {
    RegisterView()
}
