# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    describe 'uniqueness of username' do
      let(:username) { Faker::Name.last_name }

      before do
        create(:user, username: username)
      end

      subject { build(:user, username: username) }
      it 'is validated' do
        expect(subject.valid?).to eq false
        expect(subject.errors[:username]).to match([/has already been taken/i])
      end
    end
  end
end
