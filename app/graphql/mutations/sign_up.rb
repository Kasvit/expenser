module Mutations
  class SignUp < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    def resolve(email:, password:)
      user = User.new(email: email, password: password)
      if user.save
        token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
        { user: user, token: token }
      else
        GraphQL::ExecutionError.new("Invalid signup: #{user.errors.full_messages.join(', ')}")
      end
    end
  end
end
