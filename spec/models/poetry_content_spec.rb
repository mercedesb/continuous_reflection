# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PoetryContent, type: :model do
  describe "associations" do
    it { is_expected.to have_one(:journal_entry) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:poem) }
    it { is_expected.to validate_presence_of(:journal_entry).with_message("journal can't be blank") }
    it { is_expected.to accept_nested_attributes_for(:journal_entry).allow_destroy(true) }
  end
end
