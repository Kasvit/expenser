# frozen_string_literal: true

class UserValidator
  extend Dry::Initializer

  param :email
  param :password

  def validate!
    raise "Invalid email format" unless email.match?(URI::MailTo::EMAIL_REGEXP)
    raise "Password too short" if password.length < 6
  end
end
