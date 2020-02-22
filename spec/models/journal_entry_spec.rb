# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JournalEntry, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:journal) }
    it { is_expected.to belong_to(:content) }
  end

  describe "validations" do
    describe "entry_type_must_match_journal_template" do
      let(:journal) { build(:journal, :poetry) }

      describe "when content_type is not in allowed list for journal template" do
        let(:prof_dev_entry) { build(:professional_development_content) }
        subject { build(:journal_entry, journal: journal, content: prof_dev_entry) }

        it 'is validated' do
          expect(subject.valid?).to eq false
          expect(subject.errors[:journal_entry_content_type]).to match([/wrong journal entry type/i])
        end
      end

      describe "when content_type is in allowed list for journal template" do
        let(:poetry_entry) { build(:poetry_entry) }
        subject { build(:journal_entry, journal: journal, content: poetry_entry) }

        it 'is validated' do
          expect(subject.valid?).to eq true
        end
      end
    end
  end
end
