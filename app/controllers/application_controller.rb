# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActionController::ParameterMissing, with: :render_bad_request_response

  def current_user
    payload = AuthToken.decode(token)
    @current_user ||= User.find_by(username: payload[0]['sub']) if payload.present?
  end

  def logged_in?
    current_user != nil
  end

  def authenticate_user!
    head :unauthorized unless logged_in?
  end

  private

  def token
    params.permit(:token)["token"]
  end

  def render_unprocessable_entity_response(exception)
    render json: exception.record.errors, status: :unprocessable_entity
  end

  def render_not_found_response(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_bad_request_response(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
