# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  before do
    request.accept = "application/json"
  end

  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: { token: jwt }
      expect(response).to be_successful
    end
  end
end
