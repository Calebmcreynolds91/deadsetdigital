//
//  AddBudgetView.swift
//  DeadSetApp
//
//  Created on 2025-01-13.
//

import SwiftUI

struct AddBudgetView: View {
    @ObservedObject var viewModel: BudgetViewModel
    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var period: Budget.BudgetPeriod = .monthly
    @State private var category: String = ""

    let commonCategories = [
        "Groceries", "Dining Out", "Transportation", "Entertainment",
        "Shopping", "Bills", "Healthcare", "Personal Care",
        "Gas", "Rent/Mortgage", "Other"
    ]

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Budget Name", text: $name)
                    TextField("Category", text: $category)

                    Picker("Period", selection: $period) {
                        ForEach(Budget.BudgetPeriod.allCases, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                }

                Section {
                    HStack {
                        Text("$")
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                    }
                } header: {
                    Text("Budget Amount")
                }

                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(commonCategories, id: \.self) { cat in
                                Button(action: {
                                    category = cat
                                    if name.isEmpty {
                                        name = cat
                                    }
                                }) {
                                    Text(cat)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(category == cat ? Color.accentColor : Color.gray.opacity(0.2))
                                        .foregroundColor(category == cat ? .white : .primary)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("Quick Categories")
                }
            }
            .navigationTitle("New Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveBudget()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }

    private var isValid: Bool {
        !name.isEmpty && !amount.isEmpty && Decimal(string: amount) != nil
    }

    private func saveBudget() {
        guard let decimalAmount = Decimal(string: amount) else { return }

        let budget = Budget(
            name: name,
            amount: decimalAmount,
            period: period,
            category: category,
            color: "blue"
        )

        viewModel.addBudget(budget)
        dismiss()
    }
}

#Preview {
    AddBudgetView(viewModel: BudgetViewModel())
}
