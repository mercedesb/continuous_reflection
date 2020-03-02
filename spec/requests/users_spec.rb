# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }
  let(:json) { JSON.parse(response.body) }

  describe "GET /users" do
    let!(:user) { create(:user) }

    it "returns a success response" do
      get users_path, params: { token: jwt }
      expect(response).to have_http_status(200)
    end

    it "returns the expected JSON" do
      get users_path, params: { token: jwt }
      entry = json[0]
      expect(entry.key?("id")).to be true
      expect(entry["username"]).to eq user.username
      expect(entry["name"]).to eq user.name
    end
  end

  describe "GET /professional_development/entries/:id" do
    let!(:user) { create(:user) }

    it "returns a success response" do
      get user_path(user.id), params: { token: jwt }
      expect(response).to be_successful
    end

    it "returns the expected JSON" do
      get user_path(user.id), params: { token: jwt }
      expect(json.key?("id")).to be true
      expect(json["username"]).to eq user.username
      expect(json["name"]).to eq user.name
    end
  end
end
