# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { create(:category) }

  it 'is valid with valid attributes' do
    expect(category).to be_valid
  end
end
