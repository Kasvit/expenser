# == Schema Information
#
# Table name: expenses
#
#  id          :bigint           not null, primary key
#  amount      :decimal(10, 2)   not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_expenses_on_category_id  (category_id)
#  index_expenses_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:expense) { create(:expense, user: user, category: category, amount: 50, description: 'Lunch') }

  it 'is valid with valid attributes' do
    expect(expense).to be_valid
  end

  it 'is invalid with negative amount' do
    expense.amount = -10
    expect { expense.save }.to raise_error('Amount must be positive')
  end
end
