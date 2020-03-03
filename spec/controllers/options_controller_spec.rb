# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OptionsController, type: :controller do
  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }

  describe "GET #mood" do
    it "returns a success response" do
      get :mood, params: { token: jwt }
      expect(response).to be_successful
    end

    it "assigns @moods" do
      get :mood, params: { token: jwt }
      expect(subject.view_assigns["moods"]).to eq ProfessionalDevelopmentContent::Mood.options
    end
  end
end
