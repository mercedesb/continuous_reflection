# frozen_string_literal: true

require "rails_helper"

RSpec.describe HomeController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/").to route_to("home#index", format: :json)
    end

    it "routes to #journal_entries" do
      expect(get: "/home/journal_entries").to route_to("home#journal_entries", format: :json)
    end
  end
end
