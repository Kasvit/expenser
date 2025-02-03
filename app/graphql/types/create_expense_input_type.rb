module Types
  class CreateExpenseInputType < BaseInputObject
    argument :categoryId, ID, required: true
    argument :amount, Float, required: true
    argument :description, String, required: false
  end
end
