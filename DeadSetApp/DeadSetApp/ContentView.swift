//
//  ContentView.swift
//  DeadSetApp
//
//  Created on 2025-01-13.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BudgetViewModel()
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var showAddBudget = false
    @State private var selectedTab = 0
    @State private var hasLoadedDemoData = false

    var body: some View {
        TabView(selection: $selectedTab) {
            // Dashboard Tab
            DashboardView(viewModel: viewModel, onScanReceipt: {
                showCamera = true
            })
            .tabItem {
                Label("Dashboard", systemImage: "chart.pie.fill")
            }
            .tag(0)

            // Receipts Tab
            ReceiptsListView(viewModel: viewModel, onScanReceipt: {
                showCamera = true
            })
            .tabItem {
                Label("Receipts", systemImage: "doc.text.fill")
            }
            .tag(1)

            // Budgets Tab
            BudgetsListView(viewModel: viewModel, onAddBudget: {
                showAddBudget = true
            })
            .tabItem {
                Label("Budgets", systemImage: "dollarsign.circle.fill")
            }
            .tag(2)

            // Settings Tab
            SettingsView(authManager: authManager)
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(3)
        }
        .accentColor(Color("AccentColor"))
        .sheet(isPresented: $showCamera) {
            CameraView { image in
                Task {
                    await viewModel.processImage(image)
                }
            }
        }
        .sheet(isPresented: $showPhotoPicker) {
            PhotoPickerView { image in
                Task {
                    await viewModel.processImage(image)
                }
            }
        }
        .sheet(isPresented: $showAddBudget) {
            AddBudgetView(viewModel: viewModel)
        }
        .onAppear {
            // Load demo data once when demo mode is active
            if authManager.isDemoMode && !hasLoadedDemoData {
                viewModel.loadDemoData()
                hasLoadedDemoData = true
            }
        }
    }
}

// MARK: - Dashboard View

struct DashboardView: View {
    @ObservedObject var viewModel: BudgetViewModel
    var onScanReceipt: () -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Paper-style header
                    VStack(spacing: 8) {
                        Text("Your Budget")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundColor(.primary)

                        Text("Paper People, Digital Tracking")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)

                    // Overall summary card
                    SummaryCard(summary: viewModel.overallSummary())
                        .padding(.horizontal)

                    // Recent receipts
                    if !viewModel.receipts.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Recent Receipts")
                                    .font(.headline)
                                Spacer()
                                NavigationLink("See All") {
                                    ReceiptsListView(viewModel: viewModel, onScanReceipt: onScanReceipt)
                                }
                                .font(.subheadline)
                            }
                            .padding(.horizontal)

                            ForEach(viewModel.receipts.prefix(5)) { receipt in
                                NavigationLink(destination: ReceiptDetailView(receipt: receipt, viewModel: viewModel)) {
                                    ReceiptRow(receipt: receipt)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }

                    // Budget categories
                    if !viewModel.budgets.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Budget Categories")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(viewModel.budgets) { budget in
                                BudgetCard(budget: budget, summary: viewModel.budgetSummary(for: budget))
                            }
                        }
                    }

                    // Empty state
                    if viewModel.receipts.isEmpty && viewModel.budgets.isEmpty {
                        EmptyStateView(onScanReceipt: onScanReceipt)
                    }

                    Spacer(minLength: 100)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: onScanReceipt) {
                        Image(systemName: "camera.fill")
                            .font(.title3)
                    }
                }
            }
        }
    }
}

// MARK: - Summary Card

struct SummaryCard: View {
    let summary: BudgetSummary

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Budget")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(summary.totalBudget.formatted(.currency(code: "USD")))
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Remaining")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(summary.remaining.formatted(.currency(code: "USD")))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(summary.remaining >= 0 ? .green : .red)
                }
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)

                    Rectangle()
                        .fill(progressColor(for: summary.percentageUsed))
                        .frame(width: geometry.size.width * CGFloat(min(summary.percentageUsed, 1.0)), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)

            HStack {
                Text("Spent: \(summary.totalSpent.formatted(.currency(code: "USD")))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(summary.percentageUsed * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }

    private func progressColor(for percentage: Double) -> Color {
        if percentage < 0.7 {
            return .green
        } else if percentage < 0.9 {
            return .orange
        } else {
            return .red
        }
    }
}

// MARK: - Receipt Row

struct ReceiptRow: View {
    let receipt: Receipt

    var body: some View {
        HStack(spacing: 12) {
            // Receipt thumbnail or icon
            if let imageData = receipt.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "doc.text")
                            .foregroundColor(.gray)
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(receipt.merchantName.isEmpty ? "Unknown Merchant" : receipt.merchantName)
                    .font(.headline)
                    .lineLimit(1)

                Text(receipt.displayDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(receipt.totalAmount.formatted(.currency(code: "USD")))
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        )
        .padding(.horizontal)
    }
}

// MARK: - Budget Card

struct BudgetCard: View {
    let budget: Budget
    let summary: BudgetSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(budget.name)
                    .font(.headline)
                Spacer()
                Text(budget.period.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            HStack {
                Text("Spent: \(summary.totalSpent.formatted(.currency(code: "USD")))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("of \(budget.amount.formatted(.currency(code: "USD")))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                        .cornerRadius(3)

                    Rectangle()
                        .fill(progressColor(for: summary.percentageUsed))
                        .frame(width: geometry.size.width * CGFloat(min(summary.percentageUsed, 1.0)), height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        )
        .padding(.horizontal)
    }

    private func progressColor(for percentage: Double) -> Color {
        if percentage < 0.7 {
            return .green
        } else if percentage < 0.9 {
            return .orange
        } else {
            return .red
        }
    }
}

// MARK: - Empty State

struct EmptyStateView: View {
    var onScanReceipt: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "doc.text.viewfinder")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.5))
                .padding()

            VStack(spacing: 8) {
                Text("Ready to Track Your Budget?")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Snap a photo of your receipt\nor budget sheet to get started")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button(action: onScanReceipt) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Scan Your First Receipt")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(12)
            }
        }
        .padding()
        .padding(.top, 40)
    }
}

#Preview {
    ContentView()
}
