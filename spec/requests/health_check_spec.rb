require 'swagger_helper'

RSpec.describe 'Health Check', type: :request do
  path '/health_check' do
    get 'Health Check' do
      tags 'Health Check'
      produces 'application/json'

      response '200', 'status OK' do
        run_test!
      end
    end
  end
end
