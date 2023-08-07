import SwiftUI

public struct Expense: Identifiable {
    public let id = UUID()
    var date: Date
    var amount: Double
    var category: ExpenseCategory
}
