import Foundation

enum Texts: String {
    case amount = "amount_placeholder"
    case date = "date_placeholder"
    case category = "category_placeholder"
    case currency = "currency"
    case title = "title"
    case clearExpenses = "clear_expenses"
    case clearMessage = "clear_message"
    case clearTitle = "clear_title"
    
    func localized() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
}
