# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :request do
  let(:headers) do
    {
      'ACCEPT' => 'application/json',     # This is what Rails 4 accepts
      'HTTP_ACCEPT' => 'application/json' # This is what Rails 3 accepts
    }
  end
  let(:json) { JSON.parse(response.body) }

  describe 'home' do
    it 'has a success status' do
      get '/home', params: {}, headers: headers

      expect(response.content_type).to match(%r{application/json}i)
      expect(response).to have_http_status(:ok)
    end

    it 'returns the expected json' do
      get '/home', params: {}, headers: headers
      expect(json['success']).to be true
    end
  end
end
