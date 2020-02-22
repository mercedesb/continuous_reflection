# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfessionalDevelopmentContent, type: :model do
  describe "associations" do
    it { is_expected.to have_one(:journal_entry) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_inclusion_of(:mood).in_array(ProfessionalDevelopmentContent::Mood.all).allow_nil }
    it { is_expected.to accept_nested_attributes_for(:journal_entry).allow_destroy(true) }
  end
end
