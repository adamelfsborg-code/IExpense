//
//  AddView.swift
//  IExpense
//
//  Created by Adam Elfsborg on 2024-07-18.
//

import SwiftData
import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    let settings = Settings()
    
    @Bindable var expenseItem: ExpenseItem
    
    let types = ["Personal", "Business"]
    var body: some View {
        VStack {
            Form {
               
                TextField("Name", text: $expenseItem.name)
                
                Picker("Type", selection: $expenseItem.type) {
                    ForEach(types, id: \.self) {
                        Text("\($0)")
                    }
                }
                
                TextField("Amount", value: $expenseItem.amount, format: .currency(code: settings.currency))
                    .keyboardType(.decimalPad)
            }
        }
        .navigationTitle("Edit Expense")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                
                Button("Save") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                
                Button("Cancel") {
                    dismiss()
                }
            }
            
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
        let expenseItem = ExpenseItem(name: "None", type: "Personal", amount: 0)
        return AddView(expenseItem: expenseItem)
            .modelContainer(container)
    } catch {
        return Text("Failed to show preview: \(error.localizedDescription)")
    }
}
