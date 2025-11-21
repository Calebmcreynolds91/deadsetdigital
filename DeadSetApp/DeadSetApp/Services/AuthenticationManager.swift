//
//  AuthenticationManager.swift
//  DeadSetApp
//
//  Created on 2025-01-13.
//

import Foundation
import Security
import Combine

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var hasAccount = false
    @Published var isDemoMode = false

    private let service = "com.deadsetapp.budgetsnap"
    private let accountKey = "userAccount"
    private let passwordKey = "userPassword"

    init() {
        checkAuthenticationStatus()
    }

    // MARK: - Public Methods

    func checkAuthenticationStatus() {
        hasAccount = checkIfAccountExists()
        isAuthenticated = false // User needs to sign in each time they open the app
    }

    func signUp(email: String, password: String) -> Result<Void, AuthError> {
        // Validate inputs
        guard !email.isEmpty else {
            return .failure(.invalidEmail)
        }

        guard password.count >= 6 else {
            return .failure(.passwordTooShort)
        }

        // Check if account already exists
        if checkIfAccountExists() {
            return .failure(.accountAlreadyExists)
        }

        // Store credentials
        guard saveToKeychain(email: email, password: password) else {
            return .failure(.keychainError)
        }

        hasAccount = true
        isAuthenticated = true
        return .success(())
    }

    func signIn(email: String, password: String) -> Result<Void, AuthError> {
        // Validate inputs
        guard !email.isEmpty else {
            return .failure(.invalidEmail)
        }

        guard !password.isEmpty else {
            return .failure(.invalidPassword)
        }

        // Retrieve stored credentials
        guard let storedCredentials = retrieveFromKeychain() else {
            return .failure(.accountNotFound)
        }

        // Verify credentials
        if storedCredentials.email == email && storedCredentials.password == password {
            isAuthenticated = true
            return .success(())
        } else {
            return .failure(.invalidCredentials)
        }
    }

    func signOut() {
        isAuthenticated = false
        isDemoMode = false
    }

    func enableDemoMode() {
        isDemoMode = true
        isAuthenticated = true
    }

    func deleteAccount() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]

        let status = SecItemDelete(query as CFDictionary)

        if status == errSecSuccess || status == errSecItemNotFound {
            hasAccount = false
            isAuthenticated = false
            return true
        }

        return false
    }

    // MARK: - Private Methods

    private func checkIfAccountExists() -> Bool {
        return retrieveFromKeychain() != nil
    }

    private func saveToKeychain(email: String, password: String) -> Bool {
        // Create credential data
        let credentials = "\(email):\(password)"
        guard let data = credentials.data(using: .utf8) else { return false }

        // Delete any existing item
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: accountKey
        ]
        SecItemDelete(deleteQuery as CFDictionary)

        // Add new item
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: accountKey,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    private func retrieveFromKeychain() -> (email: String, password: String)? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: accountKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let credentials = String(data: data, encoding: .utf8) else {
            return nil
        }

        let components = credentials.split(separator: ":", maxSplits: 1)
        guard components.count == 2 else { return nil }

        return (email: String(components[0]), password: String(components[1]))
    }
}

// MARK: - Auth Error

enum AuthError: LocalizedError {
    case invalidEmail
    case invalidPassword
    case passwordTooShort
    case invalidCredentials
    case accountAlreadyExists
    case accountNotFound
    case keychainError

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .invalidPassword:
            return "Please enter your password"
        case .passwordTooShort:
            return "Password must be at least 6 characters"
        case .invalidCredentials:
            return "Invalid email or password"
        case .accountAlreadyExists:
            return "An account already exists. Please sign in instead."
        case .accountNotFound:
            return "No account found. Please sign up first."
        case .keychainError:
            return "Failed to save credentials securely"
        }
    }
}
