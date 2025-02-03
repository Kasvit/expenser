require 'rails_helper'

RSpec.describe Mutations::SignIn, type: :request do
  let(:user) { create(:user, password: 'password') }

  it 'signs in a user and returns a token' do
    post '/graphql', params: { query: <<~GQL }
      mutation {
        signIn(input: { email: "#{user.email}", password: "password" }) {
          token
        }
      }
    GQL

    json = JSON.parse(response.body)

    expect(json['errors']).to be_nil

    expect(json['data']['signIn']['token']).not_to be_nil
  end
end
