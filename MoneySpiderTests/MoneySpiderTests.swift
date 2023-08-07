import XCTest
@testable import MoneySpider

final class MoneySpiderTests: XCTestCase {
    
    var viewModel: ExpenseViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ExpenseViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testAddExpense() {
        viewModel.amountInput = "100"
        viewModel.selectedCategoryIndex = 1
        
        viewModel.addExpense()
        
        XCTAssertEqual(viewModel.expenses.count, 1)
        XCTAssertEqual(viewModel.expenses.first?.amount, 100)
        XCTAssertEqual(viewModel.expenses.first?.category, viewModel.categories[1])
    }
    
    func testDeleteExpense() {
        let expense = Expense(date: Date(), amount: 200, category: .food)
        viewModel.expenses = [expense]
        
        viewModel.deleteExpense(at: IndexSet(integer: 0))
        
        XCTAssertTrue(viewModel.expenses.isEmpty)
    }
    
    func testClearExpenses() {
        let expenses = [Expense(date: Date(), amount: 100, category: .food),
                        Expense(date: Date(), amount: 150, category: .health)]
        viewModel.expenses = expenses
        
        viewModel.clearExpenses()
        
        XCTAssertTrue(viewModel.expenses.isEmpty)
    }
    
    func testUpdateCategoryFrequency() {
        let expenses = [Expense(date: Date(), amount: 100, category: .food),
                        Expense(date: Date(), amount: 150, category: .transportation),
                        Expense(date: Date(), amount: 170, category: .transportation),
                        Expense(date: Date(), amount: 200, category: .health)]
        viewModel.expenses = expenses
        
        viewModel.updateCategoryFrequency()
        
        XCTAssertEqual(viewModel.categories.count, 3)
        
        XCTAssertTrue(viewModel.categories[0] == .food)
        XCTAssertTrue(viewModel.categories[1] == .transportation)
        XCTAssertTrue(viewModel.categories[2] == .health)
        
        XCTAssertEqual(viewModel.categories[0].weight, 1)
        XCTAssertEqual(viewModel.categories[1].weight, 2)
        XCTAssertEqual(viewModel.categories[2].weight, 1)
    }
    
    func testUpdateCategorySumm() {
        let expenses = [Expense(date: Date(), amount: 100, category: .food),
                        Expense(date: Date(), amount: 200, category: .food),
                        Expense(date: Date(), amount: 300, category: .transportation),
                        Expense(date: Date(), amount: 400, category: .transportation),
                        Expense(date: Date(), amount: 500, category: .health),
                        Expense(date: Date(), amount: 600, category: .health)]
        viewModel.expenses = expenses
        viewModel.amountInput = "550"
        
        viewModel.updateCategorySumm()
        
        XCTAssertEqual(viewModel.categories.count, 3)
        
        XCTAssertEqual(viewModel.categories[0].summRange.lowerBound, 500)
        XCTAssertEqual(viewModel.categories[0].summRange.upperBound, 600)
        
        XCTAssertEqual(viewModel.categories[1].summRange.lowerBound, 100)
        XCTAssertEqual(viewModel.categories[1].summRange.upperBound, 200)
        
        XCTAssertEqual(viewModel.categories[2].summRange.lowerBound, 300)
        XCTAssertEqual(viewModel.categories[2].summRange.upperBound, 400)
        
        XCTAssertTrue(viewModel.categories[0] == .health)
        XCTAssertTrue(viewModel.categories[1] == .food)
        XCTAssertTrue(viewModel.categories[2] == .transportation)
    }
    
}
