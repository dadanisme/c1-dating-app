//
//  LoginView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 10/04/25.

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    @StateObject var authViewModel = AuthViewModel()
    
    func signIn() {
        showAlert = true
    }
    
    func signInWithGoogle() {
        isLoading = true
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController
        else {
            print("❌ No rootViewController found")
            return
        }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            guard error == nil else {
                isLoading = false
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                isLoading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { _, error in
                guard error == nil else {
                    isLoading = false
                    return
                }
                // At this point, our user is signed in
                isLoading = false
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Login Page")
                    .font(.largeTitle)
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                VStack {
                    Button(action: signIn) {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    HStack {
                        VStack {
                            Divider()
                        }
                        Text("Or")
                            .font(.callout)
                            .foregroundStyle(.brown)
                        VStack {
                            Divider()
                        }
                    }
                    Button(action: signInWithGoogle) {
                        HStack {
                            Image("g")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(isLoading ? "Signing In..." : "Sign In with Google")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 7.0)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .cornerRadius(8)
                    .disabled(isLoading)
                }
                HStack {
                    Text("Don't have an account?")
                    NavigationLink("Register") {
                        RegisterView()
                    }
                }
                .padding(.top)
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
}

#Preview {
    LoginView()
}
