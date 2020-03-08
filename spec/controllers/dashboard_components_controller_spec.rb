# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardComponentsController, type: :controller do
  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }

  let(:valid_attributes) { attributes_for(:dashboard_component).merge!(journal_id: create(:journal, user: current_user).id) }
  let(:invalid_attributes) { attributes_for(:dashboard_component).merge!(component_type: nil) }

  describe "GET #index" do
    let(:dashboard) { create(:dashboard, user: current_user) }
    let!(:dashboard_component) { create(:dashboard_component, dashboard: dashboard) }

    it "returns a success response" do
      get :index, params: { token: jwt }
      expect(response).to be_successful
    end

    it "assigns @dashboard_components" do
      get :index, params: { token: jwt }
      expect(subject.view_assigns["dashboard_components"]).to eq([dashboard_component])
    end
  end

  describe "GET #show" do
    let(:dashboard) { create(:dashboard, user: current_user) }
    let!(:dashboard_component) { create(:dashboard_component, dashboard: dashboard) }

    it "returns a success response" do
      get :show, params: { id: dashboard_component.to_param, token: jwt }
      expect(response).to be_successful
    end

    it "assigns @dashboard_component" do
      get :show, params: { id: dashboard_component.to_param, token: jwt }
      expect(subject.view_assigns["dashboard_component"]).to eq(dashboard_component)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "returns a success response" do
        post :create, params: { dashboard_component: valid_attributes, token: jwt }
        expect(response).to be_successful
      end

      it "assigns @dashboard_component" do
        post :create, params: { dashboard_component: valid_attributes, token: jwt }
        expect(subject.view_assigns["dashboard_component"]).to_not be_nil
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        post :create, params: { dashboard_component: invalid_attributes, token: jwt }
        expect(response).to_not be_successful
      end
    end
  end

  describe "PUT #update" do
    let!(:dashboard_component) { create(:dashboard_component) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:dashboard_component) }

      it "returns a success response" do
        put :update, params: { id: dashboard_component.to_param, dashboard_component: new_attributes, token: jwt }
        expect(response).to be_successful
      end

      it "assigns @dashboard_component" do
        put :update, params: { id: dashboard_component.to_param, dashboard_component: new_attributes, token: jwt }
        dashboard_component.reload
        expect(subject.view_assigns["dashboard_component"]).to eq(dashboard_component)
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        put :update, params: { id: dashboard_component.to_param, dashboard_component: invalid_attributes, token: jwt }
        expect(response).to_not be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:dashboard_component) { create(:dashboard_component) }

    it "returns a success response" do
      delete :destroy, params: { id: dashboard_component.to_param, token: jwt }
      expect(response).to be_successful
    end
  end
end
