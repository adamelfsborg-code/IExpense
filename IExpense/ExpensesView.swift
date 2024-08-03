//
//  ExpensesView.swift
//  IExpense
//
//  Created by Adam Elfsborg on 2024-08-03.
//
import SwiftData
import SwiftUI

struct ExpensesView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [ExpenseItem]
    
    var body: some View {
        List {
            ForEach(expenses) { expense in
                NavigationLink(value: expense) {
                    ExpenseView(item: expense)
                }
            }.onDelete(perform: deleteExpense)
        }
    }
    
    init(filterType: String, sortOrder: [SortDescriptor<ExpenseItem>]) {
        _expenses = Query(
            filter: #Predicate { expense in
                return filterType == "" ? true : expense.type == filterType
            },
            sort: sortOrder
        )
    }
    
    func deleteExpense(at offsets: IndexSet) -> Void {
        for offset in offsets {
            let item = expenses[offset]
            modelContext.delete(item)
        }
    }
}

#Preview {
    ExpensesView(filterType: "", sortOrder: [SortDescriptor(\ExpenseItem.name)])
}
