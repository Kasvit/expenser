module Queries
  class FetchExpenses < Queries::BaseQuery
    type [ Types::ExpenseType ], null: false

    def resolve
      Expense.all
    end
  end
end
