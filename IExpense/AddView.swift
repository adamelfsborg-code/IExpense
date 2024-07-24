//
//  AddView.swift
//  IExpense
//
//  Created by Adam Elfsborg on 2024-07-18.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = "Placeholder..."
    @State private var type = "Personal"
    @State private var amount = 0.0
    let settings = Settings()
    
    var expenses: Expenses
    
    let types = ["Personal", "Business"]
    var body: some View {
        VStack {
            Form {
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text("\($0)")
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: settings.currency))
                    .keyboardType(.decimalPad)
            }
        }
        .navigationTitle($name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
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
    AddView(expenses: Expenses())
}
