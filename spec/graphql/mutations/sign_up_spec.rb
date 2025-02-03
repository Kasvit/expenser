require 'rails_helper'

RSpec.describe Mutations::SignUp, type: :request do
  it 'signs up a user and returns a token' do
    post '/graphql', params: { query: <<~GQL }
      mutation {
        signUp(input: { email: "newuser@example.com", password: "password" }) {
          token
          user {
            email
          }
        }
      }
    GQL

    json = JSON.parse(response.body)
    expect(json['errors']).to be_nil
    expect(json['data']['signUp']['token']).not_to be_nil
    expect(json['data']['signUp']['user']['email']).to eq("newuser@example.com")
  end

  it 'returns an error when signing up with invalid data' do
    post '/graphql', params: { query: <<~GQL }
      mutation {
        signUp(input: { email: "", password: "short" }) {
          token
        }
      }
    GQL

    json = JSON.parse(response.body)
    expect(json['errors']).not_to be_nil
    expect(json['errors'].first['message']).to include("Invalid signup")
  end
end
