# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :sign_up, Types::AuthPayloadType, null: false, mutation: Mutations::SignUp
    field :sign_in, Types::AuthPayloadType, null: false, mutation: Mutations::SignIn
    field :sign_out, Types::SignOutPayloadType, null: false, mutation: Mutations::SignOut
    field :create_expense, Types::ExpenseType, null: false, mutation: Mutations::CreateExpense
  end
end
