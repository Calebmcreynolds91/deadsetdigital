//
//  ReceiptDetailView.swift
//  DeadSetApp
//
//  Created on 2025-01-13.
//

import SwiftUI

struct ReceiptDetailView: View {
    let receipt: Receipt
    @ObservedObject var viewModel: BudgetViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isEditing = false
    @State private var editedReceipt: Receipt

    init(receipt: Receipt, viewModel: BudgetViewModel) {
        self.receipt = receipt
        self.viewModel = viewModel
        _editedReceipt = State(initialValue: receipt)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Receipt image
                if let imageData = editedReceipt.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .padding()
                }

                VStack(spacing: 16) {
                    // Merchant name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Merchant")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        if isEditing {
                            TextField("Merchant name", text: $editedReceipt.merchantName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(editedReceipt.merchantName.isEmpty ? "Unknown" : editedReceipt.merchantName)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Amount
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Amount")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        if isEditing {
                            HStack {
                                Text("$")
                                TextField("0.00", value: $editedReceipt.totalAmount, format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                            }
                        } else {
                            Text(editedReceipt.totalAmount.formatted(.currency(code: "USD")))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        if isEditing {
                            DatePicker("Purchase date", selection: Binding(
                                get: { editedReceipt.datePurchased ?? editedReceipt.dateCreated },
                                set: { editedReceipt.datePurchased = $0 }
                            ), displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                        } else {
                            Text(editedReceipt.displayDate.formatted(date: .long, time: .omitted))
                                .font(.body)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Category
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        if isEditing {
                            TextField("Category", text: $editedReceipt.category)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(editedReceipt.category.isEmpty ? "Uncategorized" : editedReceipt.category)
                                .font(.body)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        if isEditing {
                            TextEditor(text: $editedReceipt.notes)
                                .frame(minHeight: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        } else {
                            if !editedReceipt.notes.isEmpty {
                                Text(editedReceipt.notes)
                                    .font(.body)
                            } else {
                                Text("No notes")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Extracted text (OCR result)
                    if !editedReceipt.extractedText.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Scanned Text")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            DisclosureGroup("View extracted text") {
                                ScrollView {
                                    Text(editedReceipt.extractedText)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                }
                                .frame(maxHeight: 200)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()

                // Delete button
                if isEditing {
                    Button(role: .destructive, action: deleteReceipt) {
                        Label("Delete Receipt", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .padding()
                }
            }
        }
        .navigationTitle("Receipt Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    if isEditing {
                        viewModel.updateReceipt(editedReceipt)
                    }
                    isEditing.toggle()
                }
            }

            if isEditing {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        editedReceipt = receipt
                        isEditing = false
                    }
                }
            }
        }
    }

    private func deleteReceipt() {
        viewModel.deleteReceipt(editedReceipt)
        dismiss()
    }
}
