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
