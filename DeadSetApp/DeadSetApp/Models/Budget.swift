//
//  Budget.swift
//  DeadSetApp
//
//  Created on 2025-01-13.
//

import Foundation

struct Budget: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var amount: Decimal
    var period: BudgetPeriod
    var category: String
    var color: String

    enum BudgetPeriod: String, Codable, CaseIterable {
        case weekly = "Weekly"
        case biweekly = "Bi-Weekly"
        case monthly = "Monthly"
        case yearly = "Yearly"
    }
}

struct BudgetSummary {
    var totalBudget: Decimal
    var totalSpent: Decimal
    var remaining: Decimal

    var percentageUsed: Double {
        guard totalBudget > 0 else { return 0 }
        return Double(truncating: totalSpent as NSNumber) / Double(truncating: totalBudget as NSNumber)
    }
}
