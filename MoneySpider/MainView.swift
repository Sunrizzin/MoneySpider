import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = ExpenseViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    TextField(Texts.amount.localized(), text: $viewModel.amountInput)
                        .keyboardType(.decimalPad)
                        .onChange(of: viewModel.amountInput) { newValue in
                            newValue.isEmpty ? viewModel.updateCategoryFrequency() : viewModel.updateCategorySumm()
                        }
                    DatePicker(Texts.date.localized(), selection: $viewModel.selectedDate, in: Date()..., displayedComponents: .date)
                    Picker(Texts.category.localized(), selection: $viewModel.selectedCategoryIndex) {
                        ForEach(0..<viewModel.categories.count, id: \.self) { index in
                            Text(viewModel.categories[index].rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .listStyle(.insetGrouped)
                .frame(height: 150)
                List {
                    ForEach(viewModel.expenses) { expense in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(expense.category.rawValue)
                                    .font(.headline)
                                Text(String(format: "%.2f \(Texts.currency.localized())", expense.amount))
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(expense.date, formatter: Self.dateFormatter)")
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteExpense)
                }
                .listStyle(.insetGrouped)
                .navigationTitle(Texts.title.localized())
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            viewModel.showClearExpensesAlert = true
                        }) {
                            Image(systemName: "trash")
                                .disabled(viewModel.expenses.isEmpty)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.addExpense()
                        }) {
                            Image(systemName: "plus.rectangle.on.folder")
                                .disabled(viewModel.amountInput.isEmpty)
                        }
                    }
                }
                .alert(isPresented: $viewModel.showClearExpensesAlert) {
                    Alert(
                        title: Text(Texts.clearExpenses.localized()),
                        message: Text(Texts.clearMessage.localized()),
                        primaryButton: .destructive(Text(Texts.clearTitle.localized()), action: viewModel.clearExpenses),
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .onAppear(perform: {
            viewModel.updateCategoryFrequency()
        })
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
