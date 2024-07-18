import SwiftUI

@Observable
class User {
    var firstName = "Bilbo"
    var lastName = "Baggins"
}

struct Cheese: Codable {
    var name: String
}

struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    let name: String
    var body: some View {
        NavigationStack {
            VStack {
                Text("Oi, \(name)")
                
                List {
                    ForEach(numbers, id: \.self) {
                        Text("Row \($0)")
                    }.onDelete(perform: removeRows)
                }
                
                Button("Add row", action: addNumber)
                
                Button("Ciao") {
                    dismiss()
                }
            }
            .toolbar {
                EditButton()
            }
        }
        .padding()
    }
    
    func addNumber() {
        numbers.insert(currentNumber, at: 0)
        currentNumber += 1
    }
    
    func removeRows(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
}

struct TapView: View {
    @Environment(\.dismiss) var dismiss
    @State private var tap = UserDefaults.standard.integer(forKey: "Tap")
    @AppStorage("tapCount") private var tapCount = 0
    var body: some View {
        Button("Tap count \(tapCount) and \(tap)") {
            tapCount += 1
            tap += 1
            
            UserDefaults.standard.set(tapCount, forKey: "Tap")
        }
    }
}

struct CheeseView: View {
    @Environment(\.dismiss) var dismiss
    @State private var cheese = Cheese(name: "Formaggio")
    
    var body: some View {
        VStack {
            TextField("Cheese: \(cheese.name)", text: $cheese.name)
            
            Button("Save cheese") {
                let encoder = JSONEncoder()
                
                if let data = try? encoder.encode(cheese) {
                    UserDefaults.standard.set(data, forKey: "Cheese")
                }
            }
            
            Button("Ciao") {
                dismiss()
            }
        }
    }
}

struct ContentView: View {
    @State private var user = User()
    @State private var showingSecondSheet = false
    @State private var showingTapSheet = false
    @State private var showingCheeseSheet = false
    var body: some View {
        VStack {
            Text("\(user.firstName)")
            
            TextField("Change name", text: $user.firstName)
            
            Button("Show Second sheet") {
                showingSecondSheet = true
            }
            Button("Show Tap sheet") {
                showingTapSheet = true
            }
            Button("Show Cheese sheet") {
                showingCheeseSheet = true
            }
        }
        .sheet(isPresented: $showingSecondSheet, onDismiss: {
            print("Buongiorno")
        }, content: {
            SecondView(name: user.firstName)
        })
        .sheet(isPresented: $showingTapSheet, onDismiss: {
            print("Arrivederci")
        }, content: {
            TapView()
        })
        .sheet(isPresented: $showingCheeseSheet, onDismiss: {
            print("Formaggio")
        }, content: {
            CheeseView()
        })
    }
}

#Preview {
    ContentView()
}
