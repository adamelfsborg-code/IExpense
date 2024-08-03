import SwiftData
import SwiftUI


struct Settings {
    let currency = Locale.current.currency?.identifier ?? "USD"
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = [ExpenseItem]()
    @Query var expenses: [ExpenseItem]
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount),
    ]
    @State private var filterExpenseType: String = ""
    
    var body: some View {
        NavigationStack(path: $path) {
            ExpensesView(filterType: filterExpenseType, sortOrder: sortOrder)
                .navigationTitle("IExpense")
                .navigationDestination(for: ExpenseItem.self) { expense in
                    AddView(expenseItem: expense)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add expense", systemImage: "plus") {
                            let newExpenseItem = ExpenseItem(name: "", type: "Personal", amount: 0)
                            modelContext.insert(newExpenseItem)
                            path = [newExpenseItem]
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu("Filter", systemImage: "ellipsis.circle") {
                            Picker("Filter", selection: $filterExpenseType) {
                                Text("All").tag("")
                                Text("Personal").tag("Personal")
                                Text("Bussines").tag("Business")
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort", selection: $sortOrder) {
                                Text("Name: A-Z")
                                    .tag([
                                        SortDescriptor(\ExpenseItem.name),
                                        SortDescriptor(\ExpenseItem.amount),
                                    ])
                                Text("Name: Z-A")
                                    .tag([
                                        SortDescriptor(\ExpenseItem.name, order: .reverse),
                                        SortDescriptor(\ExpenseItem.amount),
                                    ])
                                Text("Amount: Increasing")
                                    .tag([
                                        SortDescriptor(\ExpenseItem.amount),
                                        SortDescriptor(\ExpenseItem.name),
                                    ])
                                Text("Amount: Decreasing")
                                    .tag([
                                        SortDescriptor(\ExpenseItem.amount, order: .reverse),
                                        SortDescriptor(\ExpenseItem.name),
                                    ])
                            }
                        }
                    }
                }
        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseItem.self)
}
