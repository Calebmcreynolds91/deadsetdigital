//
//  AuthenticationView.swift
//  DeadSetApp
//
//  Created on 2025-01-13.
//

import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSignUp = false
    @State private var errorMessage: String?
    @State private var showPassword = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App branding
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text.viewfinder")
                            .font(.system(size: 70))
                            .foregroundColor(.accentColor)

                        Text("BudgetSnap")
                            .font(.system(size: 36, weight: .bold, design: .serif))
                            .foregroundColor(.primary)

                        Text("Paper People, Digital Tracking")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                    // Auth form
                    VStack(spacing: 16) {
                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)

                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(.gray)
                                TextField("Enter your email", text: $email)
                                    .textContentType(.emailAddress)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )
                        }

                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)

                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(.gray)

                                if showPassword {
                                    TextField("Enter password", text: $password)
                                        .textContentType(isSignUp ? .newPassword : .password)
                                } else {
                                    SecureField("Enter password", text: $password)
                                        .textContentType(isSignUp ? .newPassword : .password)
                                }

                                Button(action: { showPassword.toggle() }) {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )

                            if isSignUp {
                                Text("Password must be at least 6 characters")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }

                        // Confirm password field (only for sign up)
                        if isSignUp {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Confirm Password")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)

                                HStack {
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(.gray)

                                    if showPassword {
                                        TextField("Confirm password", text: $confirmPassword)
                                            .textContentType(.newPassword)
                                    } else {
                                        SecureField("Confirm password", text: $confirmPassword)
                                            .textContentType(.newPassword)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray6))
                                )
                            }
                        }

                        // Error message
                        if let errorMessage = errorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                Text(errorMessage)
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.vertical, 4)
                        }

                        // Sign in/up button
                        Button(action: handleAuthentication) {
                            Text(isSignUp ? "Create Account" : "Sign In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.accentColor)
                                )
                        }
                        .padding(.top, 8)

                        // Toggle between sign in and sign up
                        Button(action: {
                            withAnimation {
                                isSignUp.toggle()
                                errorMessage = nil
                                confirmPassword = ""
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                                    .foregroundColor(.secondary)
                                Text(isSignUp ? "Sign In" : "Sign Up")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.accentColor)
                            }
                            .font(.subheadline)
                        }
                        .padding(.top, 8)

                        // Demo mode button
                        Divider()
                            .padding(.vertical, 8)

                        Button(action: {
                            authManager.enableDemoMode()
                        }) {
                            HStack {
                                Image(systemName: "play.circle")
                                Text("Continue in Demo Mode")
                            }
                            .font(.subheadline)
                            .foregroundColor(.accentColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentColor, lineWidth: 1)
                            )
                        }

                        Text("Demo mode allows you to explore the app without creating an account")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func handleAuthentication() {
        // Clear previous error
        errorMessage = nil

        // Trim whitespace
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        if isSignUp {
            // Validate password match
            if trimmedPassword != confirmPassword {
                errorMessage = "Passwords do not match"
                return
            }

            // Sign up
            let result = authManager.signUp(email: trimmedEmail, password: trimmedPassword)
            switch result {
            case .success:
                // Success - authentication manager will update isAuthenticated
                break
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        } else {
            // Sign in
            let result = authManager.signIn(email: trimmedEmail, password: trimmedPassword)
            switch result {
            case .success:
                // Success - authentication manager will update isAuthenticated
                break
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    AuthenticationView(authManager: AuthenticationManager())
}
