# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfessionalDevelopmentEntry, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_inclusion_of(:mood).in_array(ProfessionalDevelopmentEntry::Mood.all) }
  end
end
