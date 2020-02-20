# frozen_string_literal: true

class AuthenticationController < ApplicationController
  def github
    authenticator = Authenticator.new
    user_info = authenticator.github(params[:code])

    username = user_info[:login]
    name = user_info[:name]
    # avatar_url = user_info[:avatar_url]

    # Generate token...
    token = AuthToken.encode(username)
    # ... create user if it doesn't exist...
    User.where(username: username).first_or_create!(
      name: name
      # avatar_url: avatar_url
    )
    # ... and redirect to client app.
    redirect_to "#{issuer}?token=#{token}"
  rescue StandardError => e
    redirect_to "#{issuer}?error=Unable to login #{username}"
  end

  private

  def issuer
    ENV['CLIENT_URL']
  end
end
