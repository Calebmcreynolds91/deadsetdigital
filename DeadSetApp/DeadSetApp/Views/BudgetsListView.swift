//
//  BudgetsListView.swift
//  DeadSetApp
//
//  Created on 2025-01-13.
//

import SwiftUI

struct BudgetsListView: View {
    @ObservedObject var viewModel: BudgetViewModel
    var onAddBudget: () -> Void

    var body: some View {
        NavigationView {
            Group {
                if viewModel.budgets.isEmpty {
                    VStack(spacing: 24) {
                        Image(systemName: "dollarsign.circle")
                            .font(.system(size: 80))
                            .foregroundColor(.gray.opacity(0.5))
                            .padding()

                        VStack(spacing: 8) {
                            Text("No Budgets Yet")
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Create a budget to track\nyour spending by category")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        Button(action: onAddBudget) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Create Your First Budget")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.budgets) { budget in
                                BudgetCard(budget: budget, summary: viewModel.budgetSummary(for: budget))
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Budgets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: onAddBudget) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}
