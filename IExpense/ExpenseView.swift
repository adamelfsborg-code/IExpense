//
//  ExpenseView.swift
//  IExpense
//
//  Created by Adam Elfsborg on 2024-08-03.
//
import SwiftData
import SwiftUI

struct ExpenseView: View {
    var item: ExpenseItem
    let settings = Settings()
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
                    .foregroundStyle(.secondary)
                
            }
            Spacer()
            
            switch item.amount {
            case let amount where amount <= 10:
                Text(amount, format: .currency(code: settings.currency))
                    .foregroundStyle(.secondary)
            case let amount where amount <= 100:
                Text(amount, format: .currency(code: settings.currency))
                    .foregroundStyle(.orange)
            case let amount where amount >= 100:
                Text(amount, format: .currency(code: settings.currency))
                    .foregroundStyle(.red)
            default:
                Text(item.amount, format: .currency(code: settings.currency))
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("\(item.name), \(Text(item.amount, format: .currency(code: settings.currency)))")
        .accessibilityHint("\(item.type)")
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
        let expenseItem = ExpenseItem(name: "Test", type: "Personal", amount: 2000)
        return ExpenseView(item: expenseItem)
            .modelContainer(container)
    } catch {
        return Text("Failed to show preview: \(error.localizedDescription)")
    }
}
