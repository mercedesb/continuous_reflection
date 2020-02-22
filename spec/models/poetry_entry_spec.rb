# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PoetryEntry, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:poem) }
  end
end
