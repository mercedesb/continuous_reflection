# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user!

  def current_user
    payload = AuthToken.decode(token)
    @current_user ||= User.find_by(username: payload[0]['sub'])
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
end
