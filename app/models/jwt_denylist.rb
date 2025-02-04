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
class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  belongs_to :user
end
