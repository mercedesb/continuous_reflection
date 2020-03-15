# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }
  let(:json) { JSON.parse(response.body) }

  let(:valid_attributes) { attributes_for(:dashboard) }

  let(:invalid_attributes) do
    {
    }
  end

  describe "GET /dashboards" do
    describe "when the logged in user has a dashboard" do
      let!(:dashboard) { create(:dashboard, user: current_user) }
      let!(:dashboard_2) { create(:dashboard) }

      it "returns a success response" do
        get dashboards_path, params: { token: jwt }
        expect(response).to have_http_status(200)
      end

      it "only returns dashboards for the current_user" do
        get dashboards_path, params: { token: jwt }
        expect(json["id"]).to eq(dashboard.id)
      end

      it "returns the expected JSON" do
        get dashboards_path, params: { token: jwt }
        expect(json.key?("id")).to be true
      end
    end

    describe "when the logged in user does not have a dashboard" do
      it "returns a not found response" do
        get dashboards_path, params: { token: jwt }
        expect(response).to_not be_successful
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /dashboards" do
    context "with valid params" do
      it "creates a new Dashboard" do
        expect do
          post dashboards_path, params: { dashboard: valid_attributes, token: jwt }
        end.to change(Dashboard, :count).by(1)
      end

      it "associates the new dashboard with the logged in user" do
        post dashboards_path, params: { dashboard: valid_attributes, token: jwt }
        expect(Dashboard.all.first.user).to eq(current_user)
      end

      it "renders a JSON response with the new dashboard" do
        post dashboards_path, params: { dashboard: valid_attributes, token: jwt }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(%r{application/json}i)
        expect(response.location).to eq(dashboard_url(Dashboard.last))
      end

      it "returns the expected JSON" do
        post dashboards_path, params: { dashboard: valid_attributes, token: jwt }
        expect(json.key?("id")).to be true
        expect(json["userId"]).to eq current_user.id
      end
    end

    xcontext "with invalid params" do
      it "renders a JSON response with errors for the new dashboard" do
        post dashboards_path, params: { dashboard: invalid_attributes, token: jwt }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(%r{application/json}i)
      end
    end
  end

  describe "PUT /dashboard/:id" do
    let!(:dashboard) { create(:dashboard, user: current_user) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:dashboard) }

      it "updates the requested dashboard" do
        put dashboard_path(dashboard.id), params: { dashboard: new_attributes, token: jwt }
        dashboard.reload
        expect(dashboard.user_id).to eq(current_user.id)
      end

      it "renders a JSON response with the dashboard" do
        put dashboard_path(dashboard.id), params: { dashboard: new_attributes, token: jwt }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(%r{application/json}i)
      end

      it "returns the expected JSON" do
        put dashboard_path(dashboard.id), params: { dashboard: new_attributes, token: jwt }
        expect(json.key?("id")).to be true
        expect(json["user_id"]).to eq new_attributes[:user_id]
      end
    end

    xcontext "with invalid params" do
      it "renders a JSON response with errors for the dashboard" do
        put dashboard_path(dashboard.id), params: { dashboard: invalid_attributes, token: jwt }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(%r{application/json}i)
      end
    end
  end

  describe "DELETE /dashboard/:id" do
    let!(:dashboard) { create(:dashboard) }

    it "destroys the requested dashboard" do
      expect do
        delete dashboard_path(dashboard.id), params: { token: jwt }
      end.to change(Dashboard, :count).by(-1)
    end
  end
end
