require 'rails_helper'

RSpec.describe Mutations::CreateExpense, type: :request do
  let(:user) { create(:user, password: 'password123') }
  let(:category) { create(:category) }
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

  describe 'createExpense mutation' do
    let(:mutation) do
      <<~GQL
        mutation CreateExpense($input: CreateExpenseInput!) {
          createExpense(input: $input) {
            id
            amount
            description
            category {
              id
            }
          }
        }
      GQL
    end

    context 'when user is authenticated' do
      before do
        user

        @token = generate_token_for_user(user)
        @auth_headers = headers.merge('Authorization' => "Bearer #{@token}")
      end

      def generate_token_for_user(user)
        payload = {
          sub: user.id,
          scp: 'user',
          aud: nil,
          iat: Time.current.to_i,
          exp: 24.hours.from_now.to_i,
          jti: SecureRandom.uuid
        }

        JWT.encode(
          payload,
          Rails.application.credentials.jwt_secret,
          'HS256'
        )
      end

      it 'creates a new expense' do
        variables = {
          input: {
            categoryId: category.id.to_s,
            amount: 100.0,
            description: "Test expense"
          }
        }

        post '/graphql',
             params: { query: mutation, variables: variables }.to_json,
             headers: @auth_headers

        json = JSON.parse(response.body)

        expect(json['errors']).to be_nil
        expect(json.dig('data', 'createExpense')).to include(
          'amount' => 100.0,
          'description' => 'Test expense'
        )
        expect(json.dig('data', 'createExpense', 'category', 'id')).to eq(category.id.to_s)
      end

      it 'fails with invalid amount' do
        variables = {
          input: {
            categoryId: category.id.to_s,
            amount: -100.0,
            description: "Test expense"
          }
        }

        post '/graphql',
             params: { query: mutation, variables: variables }.to_json,
             headers: @auth_headers

        json = JSON.parse(response.body)
        expect(json['errors']).not_to be_nil
        expect(json['errors'].first['message']).to include('Amount must be positive')
        expect(json['errors'].first['extensions']['code']).to eq('VALIDATION_ERROR')
        expect(json['errors'].first['extensions']['errors']).to include('amount')
      end

      it 'fails with missing category' do
        variables = {
          input: {
            categoryId: '999999', # Non-existent category ID
            amount: 100.0,
            description: "Test expense"
          }
        }

        post '/graphql',
             params: { query: mutation, variables: variables }.to_json,
             headers: @auth_headers

        json = JSON.parse(response.body)
        expect(json['errors']).not_to be_nil
        expect(json['errors'].first['message']).to include('Failed to create expense')
        expect(json['errors'].first['extensions']['code']).to eq('VALIDATION_ERROR')
      end
    end

    context 'when user is not authenticated' do
      it 'returns an authentication error' do
        variables = {
          input: {
            categoryId: category.id.to_s,
            amount: 100.0,
            description: "Test expense"
          }
        }

        post '/graphql',
             params: { query: mutation, variables: variables }.to_json,
             headers: headers

        json = JSON.parse(response.body)
        expect(json['errors']).not_to be_nil
        expect(json['errors'].first['message']).to eq('Unauthorized')
      end
    end
  end
end
