require "rails_helper"

RSpec.describe PoetryEntriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/poetry_entries").to route_to("poetry_entries#index")
    end

    it "routes to #show" do
      expect(get: "/poetry_entries/1").to route_to("poetry_entries#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/poetry_entries").to route_to("poetry_entries#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/poetry_entries/1").to route_to("poetry_entries#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/poetry_entries/1").to route_to("poetry_entries#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/poetry_entries/1").to route_to("poetry_entries#destroy", id: "1")
    end
  end
end
