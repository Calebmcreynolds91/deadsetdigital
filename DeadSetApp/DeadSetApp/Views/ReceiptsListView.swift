//
//  ReceiptsListView.swift
//  DeadSetApp
//
//  Created on 2025-01-13.
//

import SwiftUI

struct ReceiptsListView: View {
    @ObservedObject var viewModel: BudgetViewModel
    var onScanReceipt: () -> Void

    var body: some View {
        NavigationView {
            Group {
                if viewModel.receipts.isEmpty {
                    EmptyStateView(onScanReceipt: onScanReceipt)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.receipts) { receipt in
                                NavigationLink(destination: ReceiptDetailView(receipt: receipt, viewModel: viewModel)) {
                                    ReceiptRow(receipt: receipt)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Receipts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: onScanReceipt) {
                        Image(systemName: "camera.fill")
                    }
                }
            }
        }
    }
}
