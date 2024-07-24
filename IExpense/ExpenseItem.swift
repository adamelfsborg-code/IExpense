import Foundation

struct ExpenseItem: Identifiable, Codable, Hashable  {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
