# frozen_string_literal: true

require "rails_helper"

RSpec.describe OptionsController, type: :routing do
  describe "routing" do
    it "routes to #mood" do
      expect(get: "/options/mood").to route_to("options#mood", format: :json)
    end
  end
end
