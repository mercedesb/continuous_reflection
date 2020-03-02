# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "ProfessionalDevelopmentContents", type: :request do
  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }
  let(:json) { JSON.parse(response.body) }

  let(:journal) { create(:journal, :professional_development) }

  let(:valid_attributes) { attributes_for(:professional_development_content).merge!(journal_entry_attributes: { journal_id: journal.id, entry_date: Faker::Date.between(from: 2.days.ago, to: Date.today) }) }
  let(:invalid_attributes) { attributes_for(:professional_development_content).merge!(title: nil).merge!(journal_entry_attributes: { journal_id: journal.id, entry_date: Faker::Date.between(from: 2.days.ago, to: Date.today) }) }

  describe "GET /professional_development_contents" do
    let!(:professional_development_content) { create(:professional_development_content, :with_entry) }

    it "returns a success response" do
      get professional_development_contents_path, params: { token: jwt }
      expect(response).to have_http_status(200)
    end

    it "returns the expected JSON" do
      get professional_development_contents_path, params: { token: jwt }
      entry = json[0]
      expect(entry.key?("id")).to be true
      expect(entry["entryDate"]).to eq professional_development_content.journal_entry.entry_date.to_s
      expect(entry["journalEntryId"]).to eq professional_development_content.journal_entry.id
      expect(entry["title"]).to eq professional_development_content.title
      expect(entry["mood"]).to eq professional_development_content.mood
      expect(entry["todayILearned"]).to eq professional_development_content.today_i_learned
      expect(entry["goalProgress"]).to eq professional_development_content.goal_progress
      expect(entry["celebrations"]).to eq professional_development_content.celebrations
    end
  end

  describe "GET /professional_development_contents/:id" do
    let!(:professional_development_content) { create(:professional_development_content, :with_entry) }

    it "returns a success response" do
      get professional_development_content_path(professional_development_content.id), params: { token: jwt }
      expect(response).to be_successful
    end

    it "returns the expected JSON" do
      get professional_development_content_path(professional_development_content.id), params: { token: jwt }
      expect(json.key?("id")).to be true
      expect(json["entryDate"]).to eq professional_development_content.journal_entry.entry_date.to_s
      expect(json["journalEntryId"]).to eq professional_development_content.journal_entry.id
      expect(json["title"]).to eq professional_development_content.title
      expect(json["mood"]).to eq professional_development_content.mood
      expect(json["todayILearned"]).to eq professional_development_content.today_i_learned
      expect(json["goalProgress"]).to eq professional_development_content.goal_progress
      expect(json["celebrations"]).to eq professional_development_content.celebrations
    end
  end

  describe "POST /professional_development_contents" do
    context "with valid params" do
      it "creates a new ProfessionalDevelopmentContent" do
        expect do
          post professional_development_contents_path, params: { professional_development_content: valid_attributes, token: jwt }
        end.to change(ProfessionalDevelopmentContent, :count).by(1)
      end

      it "renders a JSON response with the new professional_development_content" do
        post professional_development_contents_path, params: { professional_development_content: valid_attributes, token: jwt }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(%r{application/json}i)
        expect(response.location).to eq(professional_development_content_url(ProfessionalDevelopmentContent.last))
      end

      it "returns the expected JSON" do
        post professional_development_contents_path, params: { professional_development_content: valid_attributes, token: jwt }
        expect(json.key?("id")).to be true
        expect(json.key?("journalEntryId")).to be true
        expect(json["entryDate"]).to eq valid_attributes[:journal_entry_attributes][:entry_date].to_s
        expect(json["title"]).to eq valid_attributes[:title]
        expect(json["mood"]).to eq valid_attributes[:mood]
        expect(json["todayILearned"]).to eq valid_attributes[:today_i_learned]
        expect(json["goalProgress"]).to eq valid_attributes[:goal_progress]
        expect(json["celebrations"]).to eq valid_attributes[:celebrations]
      end
    end

    context "with invalid params" do
      describe "when missing professional development entry data" do
        it "renders a JSON response with errors for the new professional_development_content" do
          post professional_development_contents_path, params: { professional_development_content: invalid_attributes, token: jwt }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
        end
      end

      describe "when missing journal_entry_attributes" do
        it "renders a JSON response with errors for the new professional_development_content" do
          attributes = valid_attributes.except(:journal_entry_attributes)
          post professional_development_contents_path, params: { professional_development_content: attributes, token: jwt }
          expect(response).to have_http_status(:bad_request)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/param is missing/i)
        end
      end

      describe "when missing which journal to add it to" do
        it "renders a JSON response with errors for the new professional_development_content" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: nil })
          post professional_development_contents_path, params: { professional_development_content: attributes, token: jwt }
          expect(response).to have_http_status(:bad_request)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/value is empty/i)
        end
      end

      describe "when trying to add to the wrong journal type" do
        let(:poetry_journal) { create(:journal, :poetry) }

        it "renders a JSON response with errors for the new professional_development_content" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: poetry_journal.id, entry_date: Faker::Date.between(from: 2.days.ago, to: Date.today) })
          post professional_development_contents_path, params: { professional_development_content: attributes, token: jwt }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/wrong journal entry type/i)
        end
      end
    end
  end

  describe "PUT /professional_development_content/:id" do
    let!(:professional_development_content) { create(:professional_development_content, :with_entry) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:professional_development_content).merge(journal_entry_attributes: { journal_id: professional_development_content.journal_entry.journal_id, entry_date: Faker::Date.between(from: 2.days.ago, to: Date.today) }) }

      it "updates the requested professional_development_content" do
        put professional_development_content_path(professional_development_content.id), params: { professional_development_content: new_attributes, token: jwt }
        professional_development_content.reload
        expect(professional_development_content.journal_entry.entry_date).to eq(new_attributes[:journal_entry_attributes][:entry_date])
        expect(professional_development_content.title).to eq(new_attributes[:title])
        expect(professional_development_content.mood).to eq(new_attributes[:mood])
        expect(professional_development_content.today_i_learned).to eq(new_attributes[:today_i_learned])
        expect(professional_development_content.goal_progress).to eq(new_attributes[:goal_progress])
        expect(professional_development_content.celebrations).to eq(new_attributes[:celebrations])
      end

      it "renders a JSON response with the professional_development_content" do
        put professional_development_content_path(professional_development_content.id), params: { professional_development_content: new_attributes, token: jwt }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(%r{application/json}i)
      end

      it "returns the expected JSON" do
        put professional_development_content_path(professional_development_content.id), params: { professional_development_content: new_attributes, token: jwt }
        expect(json.key?("id")).to be true
        expect(json.key?("journalEntryId")).to be true
        expect(json["entryDate"]).to eq new_attributes[:journal_entry_attributes][:entry_date].to_s
        expect(json["title"]).to eq new_attributes[:title]
        expect(json["mood"]).to eq new_attributes[:mood]
        expect(json["todayILearned"]).to eq new_attributes[:today_i_learned]
        expect(json["goalProgress"]).to eq new_attributes[:goal_progress]
        expect(json["celebrations"]).to eq new_attributes[:celebrations]
      end

      describe "when missing journal_entry_attributes" do
        it "does not update the requested professional_development_content" do
          expect { put professional_development_content_path(professional_development_content.id), params: { professional_development_content: new_attributes, token: jwt } }.to_not change {
            professional_development_content.journal_entry.id
          }
        end
      end

      describe "when moving it to a journal of the correct type" do
        let(:professional_development_journal) { create(:journal, :professional_development) }

        it "moves the entry to that journal" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: professional_development_journal.id, entry_date: Faker::Date.between(from: 2.days.ago, to: Date.today) })
          put professional_development_content_path(professional_development_content.id), params: { professional_development_content: attributes, token: jwt }
          professional_development_content.reload
          expect(professional_development_content.journal_entry.journal.id).to eq(professional_development_journal.id)
        end
      end
    end

    context "with invalid params" do
      describe "when missing poetry entry data" do
        it "renders a JSON response with errors for the new professional_development_content" do
          put professional_development_content_path(professional_development_content.id), params: { professional_development_content: invalid_attributes, token: jwt }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
        end
      end

      describe "when trying to update it to a nil journal" do
        it "renders a JSON response with errors for the new professional_development_content" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: nil })
          put professional_development_content_path(professional_development_content.id), params: { professional_development_content: attributes, token: jwt }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/must exist/i)
        end
      end

      describe "when trying to move it to the wrong journal type" do
        let(:poetry_journal) { create(:journal, :poetry) }

        it "renders a JSON response with errors for the new professional_development_content" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: poetry_journal.id })
          put professional_development_content_path(professional_development_content.id), params: { professional_development_content: attributes, token: jwt }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/wrong journal entry type/i)
        end
      end
    end
  end

  describe "DELETE /professional_development_content/:id" do
    let!(:professional_development_content) { create(:professional_development_content, :with_entry) }

    it "destroys the requested professional_development_content" do
      expect do
        delete professional_development_content_path(professional_development_content.id), params: { token: jwt }
      end.to change(ProfessionalDevelopmentContent, :count).by(-1)
    end
  end
end
