# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:headers) do
    {
      'ACCEPT' => 'application/json',     # This is what Rails 4 accepts
      'HTTP_ACCEPT' => 'application/json' # This is what Rails 3 accepts
    }
  end

  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }
  let(:json) { JSON.parse(response.body) }

  describe "GET /users" do
    let!(:user) { create(:user) }

    it "returns a success response" do
      get users_path, params: { token: jwt }, headers: headers
      expect(response).to have_http_status(200)
    end

    it "returns the expected JSON" do
      get users_path, params: { token: jwt }, headers: headers
      entry = json[0]
      expect(entry.key?("id")).to be true
      expect(entry["username"]).to eq user.username
      expect(entry["name"]).to eq user.name
    end
  end

  describe "GET /professional_development/entries/:id" do
    let!(:user) { create(:user) }

    it "returns a success response" do
      get user_path(user.id), params: { token: jwt }, headers: headers
      expect(response).to be_successful
    end

    it "returns the expected JSON" do
      get user_path(user.id), params: { token: jwt }, headers: headers
      expect(json.key?("id")).to be true
      expect(json["username"]).to eq user.username
      expect(json["name"]).to eq user.name
    end
  end
end
