# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardComponent, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:dashboard) }
    it { is_expected.to belong_to(:journal) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:component_type) }
    it { is_expected.to validate_presence_of(:position) }
    it { is_expected.to validate_inclusion_of(:component_type).in_array(DashboardComponent::Type.all) }

    describe "journal_has_moods" do
      describe "when journal template is not in allowed list for component type" do
        let(:journal) { build(:journal, :poetry) }
        subject { build(:dashboard_component, :mood_over_time, journal: journal) }

        it 'is validated' do
          expect(subject.valid?).to eq false
          expect(subject.errors[:component_type]).to match([/cannot use the MoodOverTime component/i])
        end
      end

      describe "when journal template is in allowed list for component type" do
        let(:journal) { build(:journal, :professional_development) }
        subject { build(:dashboard_component, :mood_over_time, journal: journal) }

        it 'is validated' do
          expect(subject.valid?).to eq true
        end
      end

      describe "when component type does not need to validate journal template" do
        let(:journal) { build(:journal) }
        subject { build(:dashboard_component, :journal_calendar, journal: journal) }

        it 'is valid' do
          expect(subject.valid?).to eq true
        end
      end
    end
  end
end
