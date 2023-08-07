/**
 Enumeration representing expense categories.

 This enumeration defines the available expense categories, their identifiers, and associated data such as usage frequency and sum ranges.

 - SeeAlso: `Identifiable`
 */
enum ExpenseCategory: String, CaseIterable, Identifiable {
    /// Category "Food".
    case food = "Food"
    /// Category "Transportation".
    case transportation = "Transportation"
    /// Category "Health".
    case health = "Health"
    
    /// Private dictionary for mapping categories to their identifiers.
    private static let categoryIDs: [ExpenseCategory: Int] = [
        .food: 0,
        .transportation: 1,
        .health: 2
    ]
    
    /**
     Category identifier.

     This computed property returns the identifier of the category based on the `categoryIDs` dictionary.

     - Returns: The category identifier.
     */
    var id: Int {
        return Self.categoryIDs[self] ?? 0
    }
    
    /// Dictionary to track the frequency of category usage.
    static var categoryWeights: [ExpenseCategory: Int] = [
        .food: 0,
        .transportation: 0,
        .health: 0,
    ]
    
    /**
     Category usage weight.

     This computed property gets or sets the usage weight of the category based on the `categoryWeights` dictionary.

     - Returns: The usage weight of the category.
     */
    var weight: Int {
        get {
            return ExpenseCategory.categoryWeights[self] ?? 0
        }
        set {
            ExpenseCategory.categoryWeights[self] = newValue
        }
    }
    
    /// Dictionary to track the sum ranges for each category.
    static var categorySumm: [ExpenseCategory: ClosedRange<Double>] = [
        .food: 0.0...0.0,
        .transportation: 0.0...0.0,
        .health: 0.0...0.0
    ]
    
    /**
     Sum range for the category.

     This computed property gets or sets the sum range for the category based on the `categorySumm` dictionary.

     - Returns: The sum range for the category.
     */
    var summRange: ClosedRange<Double> {
        get {
            return ExpenseCategory.categorySumm[self] ?? 0.0...0.0
        }
        set {
            ExpenseCategory.categorySumm[self] = newValue
        }
    }
}
