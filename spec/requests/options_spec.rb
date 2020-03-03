# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Options", type: :request do
  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }
  let(:json) { JSON.parse(response.body) }

  describe "GET /mood" do
    it "returns a success response" do
      get options_mood_path, params: { token: jwt }
      expect(response).to have_http_status(200)
    end

    it "returns the expected JSON" do
      get options_mood_path, params: { token: jwt }

      expect(json).to be_kind_of(Array)

      expected = ProfessionalDevelopmentContent::Mood.options.first
      actual = json[0]

      expect(actual.key?("label")).to be true
      expect(actual["label"]).to eq expected[0].titleize
      expect(actual.key?("value")).to be true
      expect(actual["value"]).to eq expected[0]
      expect(actual.key?("ranking")).to be true
      expect(actual["ranking"]).to eq expected[1]
    end
  end
end
