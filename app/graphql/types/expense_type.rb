module Types
  class ExpenseType < Types::BaseObject
    field :id, ID, null: false
    field :amount, Float, null: false
    field :description, String, null: true
    field :category, Types::CategoryType, null: false
    field :user, Types::UserType, null: false
  end
end
