//
//  BudgetViewModel.swift
//  DeadSetApp
//
//  Created on 2025-01-13.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class BudgetViewModel: ObservableObject {
    @Published var receipts: [Receipt] = []
    @Published var budgets: [Budget] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let receiptStorageKey = "savedReceipts"
    private let budgetStorageKey = "savedBudgets"

    init() {
        loadReceipts()
        loadBudgets()
    }

    // MARK: - Demo Data

    func loadDemoData() {
        // Clear existing data first
        receipts = []
        budgets = []

        // Create sample budgets
        let groceriesBudget = Budget(
            name: "Groceries",
            amount: 600.00,
            period: .monthly,
            category: "Groceries"
        )

        let diningBudget = Budget(
            name: "Dining Out",
            amount: 300.00,
            period: .monthly,
            category: "Dining"
        )

        let entertainmentBudget = Budget(
            name: "Entertainment",
            amount: 150.00,
            period: .monthly,
            category: "Entertainment"
        )

        let transportationBudget = Budget(
            name: "Transportation",
            amount: 200.00,
            period: .monthly,
            category: "Transportation"
        )

        budgets = [groceriesBudget, diningBudget, entertainmentBudget, transportationBudget]

        // Create sample receipts with realistic data
        let calendar = Calendar.current
        let now = Date()

        var receipt1 = Receipt()
        receipt1.merchantName = "Whole Foods Market"
        receipt1.totalAmount = 87.45
        receipt1.datePurchased = calendar.date(byAdding: .day, value: -2, to: now)
        receipt1.category = "Groceries"
        receipt1.notes = "Weekly grocery shopping"

        var receipt2 = Receipt()
        receipt2.merchantName = "Starbucks"
        receipt2.totalAmount = 12.75
        receipt2.datePurchased = calendar.date(byAdding: .day, value: -3, to: now)
        receipt2.category = "Dining"
        receipt2.notes = "Morning coffee and breakfast"

        var receipt3 = Receipt()
        receipt3.merchantName = "AMC Theaters"
        receipt3.totalAmount = 45.00
        receipt3.datePurchased = calendar.date(byAdding: .day, value: -5, to: now)
        receipt3.category = "Entertainment"
        receipt3.notes = "Movie night with friends"

        var receipt4 = Receipt()
        receipt4.merchantName = "Shell Gas Station"
        receipt4.totalAmount = 52.30
        receipt4.datePurchased = calendar.date(byAdding: .day, value: -7, to: now)
        receipt4.category = "Transportation"
        receipt4.notes = "Gas fill-up"

        var receipt5 = Receipt()
        receipt5.merchantName = "Trader Joe's"
        receipt5.totalAmount = 64.20
        receipt5.datePurchased = calendar.date(byAdding: .day, value: -9, to: now)
        receipt5.category = "Groceries"
        receipt5.notes = "Mid-week groceries"

        var receipt6 = Receipt()
        receipt6.merchantName = "Chipotle"
        receipt6.totalAmount = 28.50
        receipt6.datePurchased = calendar.date(byAdding: .day, value: -10, to: now)
        receipt6.category = "Dining"
        receipt6.notes = "Lunch with coworkers"

        var receipt7 = Receipt()
        receipt7.merchantName = "Safeway"
        receipt7.totalAmount = 123.80
        receipt7.datePurchased = calendar.date(byAdding: .day, value: -14, to: now)
        receipt7.category = "Groceries"
        receipt7.notes = "Large grocery haul"

        var receipt8 = Receipt()
        receipt8.merchantName = "Netflix"
        receipt8.totalAmount = 15.99
        receipt8.datePurchased = calendar.date(byAdding: .day, value: -15, to: now)
        receipt8.category = "Entertainment"
        receipt8.notes = "Monthly subscription"

        var receipt9 = Receipt()
        receipt9.merchantName = "Uber"
        receipt9.totalAmount = 34.75
        receipt9.datePurchased = calendar.date(byAdding: .day, value: -16, to: now)
        receipt9.category = "Transportation"
        receipt9.notes = "Airport ride"

        var receipt10 = Receipt()
        receipt10.merchantName = "Olive Garden"
        receipt10.totalAmount = 68.90
        receipt10.datePurchased = calendar.date(byAdding: .day, value: -18, to: now)
        receipt10.category = "Dining"
        receipt10.notes = "Dinner date"

        receipts = [receipt1, receipt2, receipt3, receipt4, receipt5,
                   receipt6, receipt7, receipt8, receipt9, receipt10]

        // Save demo data
        saveReceipts()
        saveBudgets()
    }

    // MARK: - Receipt Management

    func addReceipt(_ receipt: Receipt) {
        receipts.insert(receipt, at: 0)
        saveReceipts()
    }

    func updateReceipt(_ receipt: Receipt) {
        if let index = receipts.firstIndex(where: { $0.id == receipt.id }) {
            receipts[index] = receipt
            saveReceipts()
        }
    }

    func deleteReceipt(_ receipt: Receipt) {
        receipts.removeAll { $0.id == receipt.id }
        saveReceipts()
    }

    func processImage(_ image: UIImage) async {
        isLoading = true
        errorMessage = nil

        await withCheckedContinuation { continuation in
            OCRService.shared.recognizeText(from: image) { [weak self] result in
                Task { @MainActor in
                    guard let self = self else {
                        continuation.resume()
                        return
                    }

                    self.isLoading = false

                    switch result {
                    case .success(let text):
                        let extractedData = OCRService.shared.extractReceiptData(from: text)

                        var newReceipt = Receipt()
                        newReceipt.extractedText = text
                        newReceipt.merchantName = extractedData.merchant ?? ""
                        newReceipt.totalAmount = extractedData.total ?? 0
                        newReceipt.datePurchased = extractedData.date

                        // Convert image to data
                        if let imageData = image.jpegData(compressionQuality: 0.7) {
                            newReceipt.imageData = imageData
                        }

                        self.addReceipt(newReceipt)

                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }

                    continuation.resume()
                }
            }
        }
    }

    // MARK: - Budget Management

    func addBudget(_ budget: Budget) {
        budgets.append(budget)
        saveBudgets()
    }

    func updateBudget(_ budget: Budget) {
        if let index = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets[index] = budget
            saveBudgets()
        }
    }

    func deleteBudget(_ budget: Budget) {
        budgets.removeAll { $0.id == budget.id }
        saveBudgets()
    }

    // MARK: - Calculations

    func totalSpent(for category: String? = nil, in period: DateInterval? = nil) -> Decimal {
        var filtered = receipts

        if let category = category {
            filtered = filtered.filter { $0.category == category }
        }

        if let period = period {
            filtered = filtered.filter { receipt in
                period.contains(receipt.displayDate)
            }
        }

        return filtered.reduce(0) { $0 + $1.totalAmount }
    }

    func budgetSummary(for budget: Budget) -> BudgetSummary {
        let period = currentPeriod(for: budget.period)
        let spent = totalSpent(for: budget.category, in: period)
        let remaining = budget.amount - spent

        return BudgetSummary(
            totalBudget: budget.amount,
            totalSpent: spent,
            remaining: remaining
        )
    }

    func overallSummary() -> BudgetSummary {
        let totalBudget = budgets.reduce(0) { $0 + $1.amount }
        let totalSpent = receipts.reduce(0) { $0 + $1.totalAmount }
        let remaining = totalBudget - totalSpent

        return BudgetSummary(
            totalBudget: totalBudget,
            totalSpent: totalSpent,
            remaining: remaining
        )
    }

    private func currentPeriod(for budgetPeriod: Budget.BudgetPeriod) -> DateInterval {
        let calendar = Calendar.current
        let now = Date()

        switch budgetPeriod {
        case .weekly:
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)!.start
            let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
            return DateInterval(start: startOfWeek, end: endOfWeek)

        case .biweekly:
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)!.start
            let endOfPeriod = calendar.date(byAdding: .day, value: 14, to: startOfWeek)!
            return DateInterval(start: startOfWeek, end: endOfPeriod)

        case .monthly:
            let startOfMonth = calendar.dateInterval(of: .month, for: now)!.start
            let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            return DateInterval(start: startOfMonth, end: endOfMonth)

        case .yearly:
            let startOfYear = calendar.dateInterval(of: .year, for: now)!.start
            let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear)!
            return DateInterval(start: startOfYear, end: endOfYear)
        }
    }

    // MARK: - Persistence

    private func saveReceipts() {
        if let encoded = try? JSONEncoder().encode(receipts) {
            UserDefaults.standard.set(encoded, forKey: receiptStorageKey)
        }
    }

    private func loadReceipts() {
        if let data = UserDefaults.standard.data(forKey: receiptStorageKey),
           let decoded = try? JSONDecoder().decode([Receipt].self, from: data) {
            receipts = decoded
        }
    }

    private func saveBudgets() {
        if let encoded = try? JSONEncoder().encode(budgets) {
            UserDefaults.standard.set(encoded, forKey: budgetStorageKey)
        }
    }

    private func loadBudgets() {
        if let data = UserDefaults.standard.data(forKey: budgetStorageKey),
           let decoded = try? JSONDecoder().decode([Budget].self, from: data) {
            budgets = decoded
        }
    }
}
