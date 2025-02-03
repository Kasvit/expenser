# == Schema Information
#
# Table name: jwt_denylists
#
#  id         :bigint           not null, primary key
#  jti        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_jwt_denylists_on_jti      (jti)
#  index_jwt_denylists_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe JwtDenylist, type: :model do
  let(:jwt_denylist) { create(:jwt_denylist) }

  it 'is valid with valid attributes' do
    expect(jwt_denylist).to be_valid
  end
end
