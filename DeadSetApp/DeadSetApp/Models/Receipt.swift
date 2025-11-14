//
//  Receipt.swift
//  DeadSetApp
//
//  Created on 2025-01-13.
//

import Foundation
import SwiftUI

struct Receipt: Identifiable, Codable {
    var id: UUID = UUID()
    var imageData: Data?
    var dateCreated: Date = Date()
    var datePurchased: Date?
    var merchantName: String = ""
    var totalAmount: Decimal = 0.0
    var extractedText: String = ""
    var category: String = ""
    var notes: String = ""
    var items: [LineItem] = []
    var isManualEntry: Bool = false

    var displayDate: Date {
        datePurchased ?? dateCreated
    }
}

struct LineItem: Identifiable, Codable {
    var id: UUID = UUID()
    var description: String
    var amount: Decimal
}
