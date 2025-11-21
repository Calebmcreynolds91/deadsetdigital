//
//  SettingsView.swift
//  DeadSetApp
//
//  Created on 2025-01-13.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var authManager: AuthenticationManager
    @State private var showDeleteConfirmation = false

    var body: some View {
        NavigationView {
            List {
                // Account section
                Section {
                    if authManager.isDemoMode {
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .foregroundColor(.accentColor)
                            VStack(alignment: .leading) {
                                Text("Demo Mode")
                                    .font(.headline)
                                Text("Exploring without an account")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.accentColor)
                            Text("Account")
                                .font(.headline)
                        }
                    }
                } header: {
                    Text("Profile")
                }

                // Actions section
                Section {
                    Button(action: {
                        authManager.signOut()
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                        .foregroundColor(.accentColor)
                    }

                    if !authManager.isDemoMode {
                        Button(role: .destructive, action: {
                            showDeleteConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Account")
                            }
                        }
                    }
                }

                // App info section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("App")
                        Spacer()
                        Text("BudgetSnap")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .alert("Delete Account", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if authManager.deleteAccount() {
                        // Account deleted successfully
                    }
                }
            } message: {
                Text("Are you sure you want to delete your account? This action cannot be undone and all your data will be lost.")
            }
        }
    }
}

#Preview {
    SettingsView(authManager: AuthenticationManager())
}
