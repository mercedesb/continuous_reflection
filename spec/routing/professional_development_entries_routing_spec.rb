require "rails_helper"

RSpec.describe ProfessionalDevelopmentEntriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/professional_development_entries").to route_to("professional_development_entries#index")
    end

    it "routes to #show" do
      expect(:get => "/professional_development_entries/1").to route_to("professional_development_entries#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/professional_development_entries").to route_to("professional_development_entries#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/professional_development_entries/1").to route_to("professional_development_entries#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/professional_development_entries/1").to route_to("professional_development_entries#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/professional_development_entries/1").to route_to("professional_development_entries#destroy", :id => "1")
    end
  end
end
