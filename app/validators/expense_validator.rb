# frozen_string_literal: true

class ExpenseValidator
  extend Dry::Initializer

  param :amount

  def validate!
    raise "Amount must be positive" unless amount.to_f.positive?
  end
end
