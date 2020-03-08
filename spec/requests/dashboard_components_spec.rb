# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "DashboardComponents", type: :request do
  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }
  let(:json) { JSON.parse(response.body) }

  let(:valid_attributes) { attributes_for(:dashboard_component).merge!(dashboard_id: create(:dashboard, user: current_user).id).merge!(journal_id: create(:journal, user: current_user).id) }
  let(:invalid_attributes) { attributes_for(:dashboard_component).merge!(component_type: nil) }

  describe "GET /dashboard_components" do
    it "returns a success response" do
      get dashboard_components_path, params: { token: jwt }
      expect(response).to have_http_status(200)
    end

    describe "when the logged in user has dashboard components" do
      let(:dashboard) { create(:dashboard, user: current_user) }
      let!(:dashboard_component) { create(:dashboard_component, dashboard: dashboard) }
      let!(:dashboard_component_2) { create(:dashboard_component) }

      it "only returns dashboard_components for the current_user" do
        get dashboard_components_path, params: { token: jwt }
        expect(json.pluck("id")).to match_array([dashboard_component.id])
      end

      it "returns the expected JSON" do
        get dashboard_components_path, params: { token: jwt }
        ret_dashboard_component = json[0]
        expect(ret_dashboard_component.key?("id")).to be true
        expect(ret_dashboard_component.key?("componentType")).to be true
        expect(ret_dashboard_component["componentType"]).to eq dashboard_component.component_type
        expect(ret_dashboard_component.key?("journalId")).to be true
        expect(ret_dashboard_component["journalId"]).to eq dashboard_component.journal.id
        expect(ret_dashboard_component.key?("position")).to be true
        expect(ret_dashboard_component["position"]).to eq dashboard_component.position
      end
    end
  end

  describe "GET /dashboard_components/:id" do
    describe "when the requested dashboard_component belongs to the logged in user" do
      let(:dashboard) { create(:dashboard, user: current_user) }
      let!(:dashboard_component) { create(:dashboard_component, dashboard: dashboard) }

      it "returns a success response" do
        get dashboard_component_path(dashboard_component.id), params: { token: jwt }
        expect(response).to be_successful
      end

      it "returns the expected JSON" do
        get dashboard_component_path(dashboard_component.id), params: { token: jwt }
        expect(json.key?("id")).to be true
        expect(json.key?("componentType")).to be true
        expect(json["componentType"]).to eq dashboard_component.component_type
        expect(json.key?("journalId")).to be true
        expect(json["journalId"]).to eq dashboard_component.journal.id
        expect(json.key?("position")).to be true
        expect(json["position"]).to eq dashboard_component.position
      end
    end

    describe "when the requested dashboard_component does not belong to the logged in user" do
      let!(:dashboard_component) { create(:dashboard_component) }

      it "returns a not found response" do
        get dashboard_component_path(dashboard_component.id), params: { token: jwt }
        expect(response).to_not be_successful
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /dashboard_components" do
    context "with valid params" do
      it "creates a new DashboardComponent" do
        expect do
          post dashboard_components_path, params: { dashboard_component: valid_attributes, token: jwt }
        end.to change(DashboardComponent, :count).by(1)
      end

      describe "when the logged in user has a dashboard" do
        let!(:dashboard) { create(:dashboard, user: current_user) }

        it "associates the new dashboard_component with the logged in user's dashboard" do
          post dashboard_components_path, params: { dashboard_component: valid_attributes, token: jwt }
          expect(DashboardComponent.all.first.dashboard).to eq(dashboard)
        end
      end

      describe "when the logged in user does not hav a dashboard" do
        it "creates a new dashboard for the current_user and associates the new dashboard_component with the new dashboard" do
          expect { post dashboard_components_path, params: { dashboard_component: valid_attributes, token: jwt } }.to change { Dashboard.count }.by(1)
          expect(DashboardComponent.all.first.dashboard).to eq(Dashboard.all.first)
        end
      end

      it "renders a JSON response with the new dashboard_component" do
        post dashboard_components_path, params: { dashboard_component: valid_attributes, token: jwt }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(%r{application/json}i)
        expect(response.location).to eq(dashboard_component_url(DashboardComponent.last))
      end

      it "returns the expected JSON" do
        post dashboard_components_path, params: { dashboard_component: valid_attributes, token: jwt }
        expect(json.key?("id")).to be true
        expect(json.key?("componentType")).to be true
        expect(json["componentType"]).to eq valid_attributes[:component_type]
        expect(json.key?("journalId")).to be true
        expect(json["journalId"]).to eq valid_attributes[:journal_id]
        expect(json.key?("position")).to be true
        expect(json["position"]).to eq valid_attributes[:position]
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new dashboard_component" do
        post dashboard_components_path, params: { dashboard_component: invalid_attributes, token: jwt }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(%r{application/json}i)
      end
    end
  end

  describe "PUT /dashboard_component/:id" do
    let(:dashboard) { create(:dashboard, user: current_user) }
    let!(:dashboard_component) { create(:dashboard_component, dashboard: dashboard) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:dashboard_component).merge!(dashboard_id: create(:dashboard, user: current_user).id).merge!(journal_id: create(:journal, user: current_user).id) }

      it "updates the requested dashboard_component" do
        put dashboard_component_path(dashboard_component.id), params: { dashboard_component: new_attributes, token: jwt }
        dashboard_component.reload
        expect(dashboard_component.component_type).to eq(new_attributes[:component_type])
        expect(dashboard_component.position).to eq(new_attributes[:position])
      end

      it "renders a JSON response with the dashboard_component" do
        put dashboard_component_path(dashboard_component.id), params: { dashboard_component: new_attributes, token: jwt }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(%r{application/json}i)
      end

      it "returns the expected JSON" do
        put dashboard_component_path(dashboard_component.id), params: { dashboard_component: new_attributes, token: jwt }
        expect(json.key?("id")).to be true
        expect(json.key?("componentType")).to be true
        expect(json["componentType"]).to eq new_attributes[:component_type]
        expect(json.key?("journalId")).to be true
        expect(json["journalId"]).to eq new_attributes[:journal_id]
        expect(json.key?("position")).to be true
        expect(json["position"]).to eq new_attributes[:position]
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the dashboard_component" do
        put dashboard_component_path(dashboard_component.id), params: { dashboard_component: invalid_attributes, token: jwt }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(%r{application/json}i)
      end
    end
  end

  describe "DELETE /dashboard_component/:id" do
    let(:dashboard) { create(:dashboard, user: current_user) }
    let!(:dashboard_component) { create(:dashboard_component, dashboard: dashboard) }

    it "destroys the requested dashboard_component" do
      expect do
        delete dashboard_component_path(dashboard_component.id), params: { token: jwt }
      end.to change(DashboardComponent, :count).by(-1)
    end
  end
end
