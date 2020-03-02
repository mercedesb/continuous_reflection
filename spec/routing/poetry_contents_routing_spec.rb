# frozen_string_literal: true

require "rails_helper"

RSpec.describe PoetryContentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/poetry_contents").to route_to("poetry_contents#index", format: :json)
    end

    it "routes to #show" do
      expect(get: "/poetry_contents/1").to route_to("poetry_contents#show", id: "1", format: :json)
    end

    it "routes to #create" do
      expect(post: "/poetry_contents").to route_to("poetry_contents#create", format: :json)
    end

    it "routes to #update via PUT" do
      expect(put: "/poetry_contents/1").to route_to("poetry_contents#update", id: "1", format: :json)
    end

    it "routes to #update via PATCH" do
      expect(patch: "/poetry_contents/1").to route_to("poetry_contents#update", id: "1", format: :json)
    end

    it "routes to #destroy" do
      expect(delete: "/poetry_contents/1").to route_to("poetry_contents#destroy", id: "1", format: :json)
    end
  end
end
