# frozen_string_literal: true

require "rails_helper"

RSpec.describe DashboardComponentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/dashboard_components").to route_to("dashboard_components#index", format: :json)
    end

    it "routes to #show" do
      expect(get: "/dashboard_components/1").to route_to("dashboard_components#show", id: "1", format: :json)
    end

    it "routes to #create" do
      expect(post: "/dashboard_components").to route_to("dashboard_components#create", format: :json)
    end

    it "routes to #update via PUT" do
      expect(put: "/dashboard_components/1").to route_to("dashboard_components#update", id: "1", format: :json)
    end

    it "routes to #update via PATCH" do
      expect(patch: "/dashboard_components/1").to route_to("dashboard_components#update", id: "1", format: :json)
    end

    it "routes to #destroy" do
      expect(delete: "/dashboard_components/1").to route_to("dashboard_components#destroy", id: "1", format: :json)
    end
  end
end
