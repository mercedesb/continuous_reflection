# frozen_string_literal: true

class AuthenticationController < ApplicationController
  def github
    authenticator = Authenticator.new
    user_info = authenticator.github(params[:code])

    login = user_info[:login]
    name = user_info[:name]
    avatar_url = user_info[:avatar_url]

    # Generate token...
    token = AuthToken.encode(login)
    # ... create user if it doesn't exist...
    User.where(login: login).first_or_create!(
      name: name,
      avatar_url: avatar_url
    )
    # ... and redirect to client app.
    redirect_to "#{issuer}?token=#{token}"
  rescue StandardError => e
    redirect_to "#{issuer}?error=#{e.message}"
  end

  private

  def issuer
    ENV['CLIENT_URL']
  end
end
