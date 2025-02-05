module Mutations
  class SignIn < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    def resolve(email:, password:)
      user = User.find_by(email: email)
      return GraphQL::ExecutionError.new("Invalid email or password") unless user&.valid_password?(password)

      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      { user: user, token: token }
    end
  end
end
