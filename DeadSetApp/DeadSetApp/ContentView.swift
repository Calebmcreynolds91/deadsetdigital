//
//  ContentView.swift
//  DeadSetApp
//
//  Created on 2025-01-13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "star.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.accentColor)
                    .padding()

                Text("Welcome to DeadSet")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Your app is ready to build!")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

                VStack(spacing: 12) {
                    Text("Getting Started")
                        .font(.headline)

                    Text("This is a template iOS app built with SwiftUI and ready for the App Store.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()

                Spacer()
            }
            .navigationTitle("DeadSet")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
