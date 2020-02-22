# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProfessionalDevelopmentContentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/professional_development_contents").to route_to("professional_development_contents#index")
    end

    it "routes to #show" do
      expect(get: "/professional_development_contents/1").to route_to("professional_development_contents#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/professional_development_contents").to route_to("professional_development_contents#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/professional_development_contents/1").to route_to("professional_development_contents#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/professional_development_contents/1").to route_to("professional_development_contents#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/professional_development_contents/1").to route_to("professional_development_contents#destroy", id: "1")
    end
  end
end
