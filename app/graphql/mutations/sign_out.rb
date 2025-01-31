module Mutations
  class SignOut < BaseMutation
    argument :token, String, required: true

    type Boolean

    def resolve(token:)
      Devise::JWT::RevocationStrategies::Null.revoke(token, nil)
      true
    end
  end
end
