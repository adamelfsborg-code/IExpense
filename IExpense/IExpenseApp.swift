//
//  IExpenseApp.swift
//  IExpense
//
//  Created by Adam Elfsborg on 2024-07-18.
//
import SwiftData
import SwiftUI

@main
struct IExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
