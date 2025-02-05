module Mutations
  class SignOut < BaseMutation
    argument :token, String, required: true

    def resolve(token:)
      Devise::JWT::RevocationStrategies::Null.revoke_jwt(token, nil)
      { success: true }
    end
  end
end
