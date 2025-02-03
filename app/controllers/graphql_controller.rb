# frozen_string_literal: true

class GraphqlController < ApplicationController
  before_action :authenticate_user_from_token!
  skip_before_action :verify_authenticity_token

  def execute
    puts "Request Headers: #{request.headers.to_h.inspect}" # Debugging output
    context = {
      current_user: current_user
    }

    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    result = ExpenserSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [ { message: e.message, backtrace: e.backtrace } ], data: {} }, status: 500
  end

  def current_user
    token = request.headers["Authorization"]&.split(" ")&.last
    return nil if token.nil?

    begin
      decoded_token = JWT.decode(
        token,
        Rails.application.credentials.jwt_secret,
        true,
        algorithm: "HS256"
      )
      user_id = decoded_token.first["sub"]
      User.find_by(id: user_id)
    rescue JWT::DecodeError => e
      Rails.logger.error "JWT Decode Error: #{e.message}"
      nil
    end
  end

  def authenticate_user_from_token!
    token = request.headers["Authorization"]&.split(" ")&.last
    if token
      begin
        decoded_token = JWT.decode(token, Rails.application.credentials.jwt_secret, true, { algorithm: "HS256" })
        @current_user = User.find(decoded_token[0]["sub"])
      rescue JWT::DecodeError => e
        @current_user = nil
      end
    else
      @current_user = nil
    end
  end
end
