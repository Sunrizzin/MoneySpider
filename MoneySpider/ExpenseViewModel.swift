import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var categories: [ExpenseCategory] = ExpenseCategory.allCases
    @Published var selectedCategoryIndex = 0
    @Published var selectedDate = Date()
    @Published var amountInput = ""
    @Published var showClearExpensesAlert = false
    
    /**
     Adds a new expense to the list of expenses.
     
     This method creates a new `Expense` object using the selected parameters and then adds it to the `expenses` list. The method also updates the frequency of category usage and resets the values for the selected date, entered amount, and selected category index.
     
     - Parameters: None
     - Note:
     The method checks the correctness of the entered expense amount and the absence of an empty string. If the entered amount is valid, a new `Expense` object is created and added to the expenses array. The category usage frequency is then updated, and the values for the selected date, entered amount, and selected category index are reset in preparation for the next input.
     
     - Returns: Void
     */
    func addExpense() {
        guard let amountValue = Double(amountInput), !amountInput.isEmpty else {
            return
        }
        
        let expense = Expense(date: selectedDate, amount: amountValue, category: categories[selectedCategoryIndex])
        expenses.append(expense)
        
        selectedDate = Date()
        amountInput = ""
        selectedCategoryIndex = 0
    }
    
    /**
     Deletes expenses at the specified offsets from the list of expenses.
     
     This method removes expenses from the `expenses` list at the specified offsets. After removal, the method updates the frequency of category usage.
     
     - Parameters:
     - offsets: The indices of the expenses to be deleted.
     - Note:
     The method removes expenses at the provided offsets from the expenses array. After removal, the category usage frequency is updated to reflect the changes.
     
     - Returns: Void
     */
    func deleteExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
        updateCategorySumm()
    }
    
    /**
     Removes all expenses from the list of expenses.
     
     This method removes all expenses from the `expenses` list, effectively clearing the list. After removal, the method ensures that the category usage frequency is updated accordingly.
     
     - Parameters: None
     - Note:
     The method empties the `expenses` array, effectively clearing all expenses. After removal, the category usage frequency is updated to reflect the cleared state.
     
     - Returns: Void
     */
    func clearExpenses() {
        expenses.removeAll()
        updateCategorySumm()
    }
    
    /**
     Updates the frequency of expense categories.
     
     This method recalculates the weights of expense categories based on existing expense data. It then sorts the categories by weight and identifier order.
     
     - Parameters: None
     - Note:
     The method first resets the weights for all categories to zero. It then iterates through the list of expenses and increments the weight of the corresponding category for each expense. After that, it sorts all categories based on weight, and in case of equal weights, based on their identifiers. As a result, the list of expense categories is updated.
     
     - Returns: Void
     */
    func updateCategoryFrequency() {
        for var category in ExpenseCategory.allCases {
            category.weight = 0
        }

        expenses.forEach { expense in
            ExpenseCategory.categoryWeights[expense.category]! += 1
        }
        
        let sortedCategories = ExpenseCategory.allCases.sorted {
            if $0.id == $1.id {
                return $0.weight > $1.weight
            }
            return $0.id < $1.id
        }
        
        categories = sortedCategories
    }
    
    /**
     Updates the expense sum ranges for categories.
     
     This method recalculates expense sum ranges for each category based on existing expense data. It then updates the category usage frequency and sorts the categories for display in the interface.
     
     - Parameters: None
     - Note:
     The method checks the correctness of the entered expense amount and the absence of an empty string. If the entered amount is valid, the method first resets the sum ranges for all categories. It then finds unique categories in the expense list and updates the sum ranges for each category based on the entered amount. Next, the method updates the category usage frequency, sorts the categories by their identifiers and weights, and combines the results with the existing list of categories.
     
     - Returns: Void
     */
    func updateCategorySumm() {
        guard let amountValue = Double(amountInput), !amountInput.isEmpty else {
            return
        }
        
        var uniqueCategories: Set<ExpenseCategory> = []
        var contCategory: Set<ExpenseCategory> = []

        expenses.forEach { expense in
            uniqueCategories.insert(expense.category)
        }
        
        if uniqueCategories.isEmpty {
            updateCategoryFrequency()
        } else {
            var categorySums: [ExpenseCategory: [Double]] = [:]
            
            for expense in expenses {
                if var sums = categorySums[expense.category] {
                    sums.append(expense.amount)
                    categorySums[expense.category] = sums
                } else {
                    categorySums[expense.category] = [expense.amount]
                }
            }
            
            for (category, sums) in categorySums {
                let newLowerBound = sums.min() ?? 0.0
                let newUpperBound = sums.max() ?? 0.0
                ExpenseCategory.categorySumm[category] = newLowerBound...newUpperBound
            }
            
            for category in Array(uniqueCategories) {
                if category.summRange.contains(amountValue) {
                    contCategory.insert(category)
                }
            }
            
            updateCategoryFrequency()
            
            let sortedIdCategories = Array(contCategory).sorted { (category1, category2) -> Bool in
                return category1.id < category2.id
            }
            
            let sortedCategories = sortedIdCategories.sorted { (category1, category2) -> Bool in
                return category1.weight > category2.weight
            }
            
            let combineArray = sortedCategories + categories
            
            let uniqueCategories: [ExpenseCategory] = combineArray.reduce(into: []) { result, category in
                if !result.contains(where: { $0.id == category.id }) {
                    result.append(category)
                }
            }
            
            categories = uniqueCategories
        }
    }
}
