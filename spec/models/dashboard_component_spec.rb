# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardComponent, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:dashboard) }
    it { is_expected.to have_many(:dashboard_component_journals) }
    it { is_expected.to have_many(:journals) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:component_type) }
    it { is_expected.to validate_presence_of(:position) }
    it { is_expected.to validate_inclusion_of(:component_type).in_array(DashboardComponent::Type.all) }
  end
end
