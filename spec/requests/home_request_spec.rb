# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Home", type: :request do
  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }
  let(:json) { JSON.parse(response.body) }

  describe "GET /journal_entries" do
    it "returns a success response" do
      get home_journal_entries_path, params: { token: jwt, journal_ids: '' }
      expect(response).to have_http_status(200)
    end

    describe "when the logged in user has entries" do
      let(:journal_one) { create(:journal, :poetry, user: current_user) }
      let!(:journal_entry_one) { create(:journal_entry, :poetry, journal: journal_one, entry_date: Date.current) }
      let(:journal_two) { create(:journal, :poetry, user: current_user) }
      let!(:journal_entry_two) { create(:journal_entry, :poetry, journal: journal_two, entry_date: Date.current - 1.day) }
      let(:journal_three) { create(:journal, :poetry, user: current_user) }
      let!(:journal_entry_three) { create(:journal_entry, :poetry, journal: journal_three) }

      it "returns all entries from the queried journals" do
        get home_journal_entries_path, params: { token: jwt, journal_ids: [journal_one.id, journal_two.id].join(",") }
        expect(json.map { |e| e["id"] }).to match_array([journal_entry_one.id, journal_entry_two.id])
      end

      it "sorts the entries by entry_date" do
        get home_journal_entries_path, params: { token: jwt, journal_ids: [journal_one.id, journal_two.id].join(",") }
        expect(json.map { |e| e["id"] }).to eq([journal_entry_two.id, journal_entry_one.id])
      end

      describe "when it's a professional development entry" do
        let!(:journal) { create(:journal, :professional_development, user: current_user) }
        let!(:journal_entry) { create(:journal_entry, :professional_development, journal: journal) }

        it "returns the expected JSON" do
          get home_journal_entries_path, params: { token: jwt, journal_ids: journal.id.to_s }
          entry = json[0]
          expect(entry.key?("id")).to be true
          expect(entry["contentId"]).to eq journal_entry.content_id
          expect(entry["contentType"]).to eq journal_entry.content_type
          expect(entry.key?("content")).to eq true

          content = entry["content"]
          expect(content["title"]).to eq journal_entry.content.title
          expect(content["mood"]).to eq journal_entry.content.mood
          expect(content["todayILearned"]).to eq journal_entry.content.today_i_learned
          expect(content["goalProgress"]).to eq journal_entry.content.goal_progress
          expect(content["celebrations"]).to eq journal_entry.content.celebrations
        end
      end

      describe "when it's a poetry entry" do
        let!(:journal) { create(:journal, :poetry, user: current_user) }
        let!(:journal_entry) { create(:journal_entry, :poetry, journal: journal) }

        it "returns the expected JSON" do
          get home_journal_entries_path, params: { token: jwt, journal_ids: journal.id.to_s }
          entry = json[0]
          expect(entry.key?("id")).to be true
          expect(entry["contentId"]).to eq journal_entry.content_id
          expect(entry["contentType"]).to eq journal_entry.content_type
          expect(entry.key?("content")).to eq true

          content = entry["content"]
          expect(content["title"]).to eq journal_entry.content.title
          expect(content["poem"]).to eq journal_entry.content.poem
        end
      end
    end

    describe "when the logged in user does not have any entries" do
      let!(:journal_entry) { create(:journal_entry) }

      it "returns an empty array" do
        get home_journal_entries_path, params: { token: jwt, journal_ids: [journal_entry.journal.id].join(",") }
        expect(json).to eq []
      end
    end
  end
end
