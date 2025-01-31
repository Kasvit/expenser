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
FactoryBot.define do
  factory :expense do
    user { nil }
    category { nil }
    amount { "9.99" }
    description { "MyText" }
  end
end
