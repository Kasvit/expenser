module Mutations
  class CreateExpense < BaseMutation
    argument :category_id, ID, required: true
    argument :amount, Float, required: true
    argument :description, String, required: false

    def resolve(category_id:, amount:, description: nil)
      authenticate_user!

      # Create expense with user association
      expense = current_user.expenses.new(
        category_id: category_id,
        amount: amount,
        description: description
      )

      begin
        if expense.save
          expense
        else
          raise GraphQL::ExecutionError.new(
            "Failed to create expense: #{expense.errors.full_messages.join(', ')}",
            extensions: {
              code: "VALIDATION_ERROR",
              errors: expense.errors.to_hash
            }
          )
        end
      rescue RuntimeError => e
        raise GraphQL::ExecutionError.new(
          "Failed to create expense: #{e.message}",
          extensions: {
            code: "VALIDATION_ERROR",
            errors: { amount: [ e.message ] }
          }
        )
      end
    end

    private

    def authenticate_user!
      raise(GraphQL::ExecutionError, "Unauthorized") unless context[:current_user]
    end

    def current_user
      context[:current_user]
    end
  end
end
