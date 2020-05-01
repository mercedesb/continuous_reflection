# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "JournalEntries", type: :request do
  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }
  let(:json) { JSON.parse(response.body) }

  describe "GET /journal_entries" do
    it "returns a success response" do
      get journal_entries_path, params: { token: jwt }
      expect(response).to have_http_status(200)
    end

    describe "when the logged in user has an entry" do
      describe "and it's a professional development entry" do
        let!(:journal) { create(:journal, :professional_development, user: current_user) }
        let!(:journal_entry) { create(:journal_entry, :professional_development, journal: journal) }

        it "returns the expected JSON" do
          get journal_entries_path, params: { token: jwt }
          entry = json[0]
          expect(entry.key?("id")).to be true
          expect(entry.key?("journal")).to be true
          expect(entry["contentId"]).to eq journal_entry.content_id
          expect(entry["contentType"]).to eq journal_entry.content_type
          expect(entry.key?("content")).to eq true

          journal_json = entry["journal"]
          expect(journal_json.key?("id")).to be true
          expect(journal_json["name"]).to eq journal.name

          content = entry["content"]
          expect(content["title"]).to eq journal_entry.content.title
          expect(content["mood"]).to eq journal_entry.content.mood
          expect(content["todayILearned"]).to eq journal_entry.content.today_i_learned
          expect(content["goalProgress"]).to eq journal_entry.content.goal_progress
          expect(content["celebrations"]).to eq journal_entry.content.celebrations
        end
      end

      describe "and it's a poetry entry" do
        let!(:journal) { create(:journal, :poetry, user: current_user) }
        let!(:journal_entry) { create(:journal_entry, :poetry, journal: journal) }

        it "returns the expected JSON" do
          get journal_entries_path, params: { token: jwt }
          entry = json[0]
          expect(entry.key?("id")).to be true
          expect(entry["contentId"]).to eq journal_entry.content_id
          expect(entry["contentType"]).to eq journal_entry.content_type
          expect(entry.key?("content")).to eq true

          journal_json = entry["journal"]
          expect(journal_json.key?("id")).to be true
          expect(journal_json["name"]).to eq journal.name

          content = entry["content"]
          expect(content["title"]).to eq journal_entry.content.title
          expect(content["poem"]).to eq journal_entry.content.poem
        end
      end

      describe "when there are multiple entries" do
        let(:journal) { create(:journal, user: current_user) }
        let!(:journal_entry) { create(:journal_entry, journal: journal) }
        let!(:journal_entry_2) { create(:journal_entry) }

        it "returns only entries for the logged in user" do
          get journal_entries_path, params: { token: jwt }
          expect(json.pluck("id")).to match_array([journal_entry.id])
        end

        describe "and querying by type" do
          let!(:journal_entry_3) { create(:journal_entry, journal: build(:journal, user: current_user, template: journal.template)) }

          it "returns only entries of that type for the logged in user" do
            get journal_entries_path, params: { token: jwt }
            expect(json.pluck("id")).to match_array([journal_entry.id, journal_entry_3.id])
          end
        end

        describe "and querying by journal" do
          let!(:journal_entry_3) { create(:journal_entry, journal: journal) }

          it "returns only entries of that type for the logged in user" do
            get journal_entries_path, params: { token: jwt }
            expect(json.pluck("id")).to match_array([journal_entry.id, journal_entry_3.id])
          end
        end
      end
    end

    describe "when the logged in user does not have any entries" do
      let!(:journal_entry) { create(:journal_entry) }

      it "returns an empty array" do
        get journal_entries_path, params: { token: jwt }
        expect(json).to eq []
      end
    end
  end

  describe "GET /journal_entries/:id" do
    describe "when the requested entry belongs to the logged in user" do
      let!(:journal) { create(:journal, user: current_user) }
      let!(:journal_entry) { create(:journal_entry, journal: journal) }

      it "returns a success response" do
        get journal_entry_path(journal_entry.id), params: { token: jwt }
        expect(response).to be_successful
      end

      describe "when it's a professional development entry" do
        let!(:journal) { create(:journal, :professional_development, user: current_user) }
        let!(:journal_entry) { create(:journal_entry, :professional_development, journal: journal) }

        it "returns the expected JSON" do
          get journal_entry_path(journal_entry.id), params: { token: jwt }
          expect(json.key?("id")).to be true
          expect(json.key?("journal")).to be true
          expect(json["contentId"]).to eq journal_entry.content_id
          expect(json["contentType"]).to eq journal_entry.content_type
          expect(json.key?("content")).to eq true

          journal_json = json["journal"]
          expect(journal_json.key?("id")).to be true
          expect(journal_json["name"]).to eq journal.name

          content = json["content"]
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
          get journal_entry_path(journal_entry.id), params: { token: jwt }
          expect(json.key?("id")).to be true
          expect(json.key?("journal")).to be true
          expect(json["contentId"]).to eq journal_entry.content_id
          expect(json["contentType"]).to eq journal_entry.content_type
          expect(json.key?("content")).to eq true

          journal_json = json["journal"]
          expect(journal_json.key?("id")).to be true
          expect(journal_json["name"]).to eq journal.name

          content = json["content"]
          expect(content["title"]).to eq journal_entry.content.title
          expect(content["poem"]).to eq journal_entry.content.poem
        end
      end
    end

    describe "when the requested entry does not belong to the logged in user" do
      let!(:journal_entry) { create(:journal_entry) }

      it "returns a not found response" do
        get journal_entry_path(journal_entry.id), params: { token: jwt }
        expect(response).to_not be_successful
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
