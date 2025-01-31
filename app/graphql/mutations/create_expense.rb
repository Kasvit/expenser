module Mutations
  class CreateExpense < BaseMutation
    argument :category_id, ID, required: true
    argument :amount, Float, required: true
    argument :description, String, required: false

    type Types::ExpenseType

    def resolve(category_id:, amount:, description: nil)
      authenticate_user!

      category = Category.find(category_id)
      expense = current_user.expenses.create!(
        category: category,
        amount: amount,
        description: description
      )
      expense
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.message)
    end
  end
end
