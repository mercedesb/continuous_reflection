# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardComponentJournal, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:dashboard_component) }
    it { is_expected.to belong_to(:journal) }
  end

  describe "validations" do
    describe "journal_has_moods" do
      describe "when journal template is not in allowed list for component type" do
        let(:journal) { build(:journal, :poetry) }
        let(:dashboard_component) { build(:dashboard_component, :mood_over_time) }
        subject { build(:dashboard_component_journal, dashboard_component: dashboard_component, journal: journal) }

        it 'is validated' do
          expect(subject.valid?).to eq false
          expect(subject.errors[:component_type]).to match([/cannot use the MoodOverTime component/i])
        end
      end

      describe "when journal template is in allowed list for component type" do
        let(:journal) { build(:journal, :professional_development) }
        let(:dashboard_component) { build(:dashboard_component, :mood_over_time) }
        subject { build(:dashboard_component_journal, dashboard_component: dashboard_component, journal: journal) }

        it 'is validated' do
          expect(subject.valid?).to eq true
        end
      end

      describe "when component type does not need to validate journal template" do
        let(:journal) { build(:journal) }
        let(:dashboard_component) { build(:dashboard_component, :journal_calendar) }
        subject { build(:dashboard_component_journal, dashboard_component: dashboard_component, journal: journal) }

        it 'is valid' do
          expect(subject.valid?).to eq true
        end
      end
    end
  end
end
