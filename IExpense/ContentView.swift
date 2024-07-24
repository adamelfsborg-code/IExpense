import SwiftUI

@Observable
class Expenses {

    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct Settings {
    let currency = Locale.current.currency?.identifier ?? "USD"
}

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
    }
}

struct ContentView: View {
    @State private var path = [Int]()
    @State private var expenses = Expenses()
    
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section("Personal") {
                    ForEach(expenses.items.filter {$0.type == "Personal" } ) { item in
                        ExpenseView(item: item)
                    }.onDelete(perform: deletePersonalItems)
                }
                
                Section("Business") {
                    ForEach(expenses.items.filter {$0.type == "Business" } ) { item in
                        ExpenseView(item: item)
                    }.onDelete(perform: deleteBusinessItems)
                }
            }
            .navigationTitle("IExpense")
            .navigationDestination(for: Int.self) { _ in
                AddView(expenses: expenses)
            }
            .toolbar {
                Button("Add expense", systemImage: "plus") {
                    path = [32]
                }
            }
        }
    }
    
    func deletePersonalItems(at offset: IndexSet) {
        var expenses = expenses.items.filter { $0.type == "Personal" }
        expenses.remove(atOffsets: offset)
    }
    
    func deleteBusinessItems(at offset: IndexSet) {
        var expenses = expenses.items.filter { $0.type == "Busniess" }
        expenses.remove(atOffsets: offset)
    }
}

#Preview {
    ContentView()
}
