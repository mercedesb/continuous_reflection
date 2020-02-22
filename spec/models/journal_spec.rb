# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Journal, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:journal_entries) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:template) }
    it { is_expected.to validate_inclusion_of(:template).in_array(Journal::Template.all) }
  end
end
