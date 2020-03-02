# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }

  let(:valid_attributes) { attributes_for(:user) }

  describe "GET #index" do
    let!(:user) { create(:user) }

    it "returns a success response" do
      get :index, params: { token: jwt }
      expect(response).to be_successful
    end

    it "assigns @users" do
      get :index, params: { token: jwt }
      expect(subject.view_assigns["users"]).to match_array([current_user, user])
    end
  end

  describe "GET #show" do
    let!(:user) { create(:user) }

    it "returns a success response" do
      get :show, params: { id: user.to_param, token: jwt }
      expect(response).to be_successful
    end

    it "assigns @user" do
      get :show, params: { id: user.to_param, token: jwt }
      expect(subject.view_assigns["user"]).to eq(user)
    end
  end
end
