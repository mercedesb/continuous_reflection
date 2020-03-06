# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }

  let(:valid_attributes) { attributes_for(:dashboard) }

  let(:invalid_attributes) do
    skip("Add a hash of attributes invalid for your model")
  end

  describe "GET #index" do
    let!(:dashboard) { create(:dashboard, user: current_user) }

    it "returns a success response" do
      get :index, params: { token: jwt }
      expect(response).to be_successful
    end

    it "assigns @dashboards" do
      get :index, params: { token: jwt }
      expect(subject.view_assigns["dashboards"]).to eq([dashboard])
    end
  end

  describe "GET #show" do
    let!(:dashboard) { create(:dashboard, user: current_user) }

    it "returns a success response" do
      get :show, params: { id: dashboard.to_param, token: jwt }
      expect(response).to be_successful
    end

    it "assigns @dashboard" do
      get :show, params: { id: dashboard.to_param, token: jwt }
      expect(subject.view_assigns["dashboard"]).to eq(dashboard)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "returns a success response" do
        post :create, params: { dashboard: valid_attributes, token: jwt }
        expect(response).to be_successful
      end

      it "assigns @dashboard" do
        post :create, params: { dashboard: valid_attributes, token: jwt }
        expect(subject.view_assigns["dashboard"]).to_not be_nil
      end
    end

    xcontext "with invalid params" do
      it "returns an error response" do
        post :create, params: { dashboard: invalid_attributes, token: jwt }
        expect(response).to_not be_successful
      end
    end
  end

  describe "PUT #update" do
    let!(:dashboard) { create(:dashboard) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:dashboard) }

      it "returns a success response" do
        put :update, params: { id: dashboard.to_param, dashboard: new_attributes, token: jwt }
        expect(response).to be_successful
      end

      it "assigns @dashboard" do
        put :update, params: { id: dashboard.to_param, dashboard: new_attributes, token: jwt }
        dashboard.reload
        expect(subject.view_assigns["dashboard"]).to eq(dashboard)
      end
    end

    xcontext "with invalid params" do
      it "returns an error response" do
        put :update, params: { id: dashboard.to_param, dashboard: invalid_attributes, token: jwt }
        expect(response).to_not be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:dashboard) { create(:dashboard) }

    it "returns a success response" do
      delete :destroy, params: { id: dashboard.to_param, token: jwt }
      expect(response).to be_successful
    end
  end
end
