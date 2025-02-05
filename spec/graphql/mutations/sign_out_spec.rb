require 'rails_helper'

RSpec.describe Mutations::SignOut, type: :request do
  let(:user) { create(:user, password: 'password') }

  before do
    post '/graphql', params: { query: <<~GQL }
      mutation {
        signIn(input: { email: "#{user.email}", password: "password" }) {
          token
        }
      }
    GQL
    @token = JSON.parse(response.body)['data']['signIn']['token']
  end

  it 'signs out a user' do
    post '/graphql', params: { query: <<~GQL, headers: { 'Authorization' => "Bearer #{@token}" } }
      mutation {
        signOut(input: { token: "#{@token}" }) {
          success
        }
      }
    GQL

    json = JSON.parse(response.body)
    expect(json['data']['signOut']['success']).to be true
  end
end
