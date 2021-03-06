# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "PoetryContents", type: :request do
  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }
  let(:json) { JSON.parse(response.body) }

  let(:journal) { create(:journal, :poetry) }

  let(:valid_attributes) { attributes_for(:poetry_content).merge!(journal_entry_attributes: { journal_id: journal.id, entry_date: Faker::Date.between(from: 2.days.ago, to: Date.today) }) }
  let(:invalid_attributes) { attributes_for(:poetry_content).merge!(title: nil).merge!(journal_entry_attributes: { journal_id: journal.id, entry_date: Faker::Date.between(from: 2.days.ago, to: Date.today) }) }

  describe "GET /poetry_contents" do
    let!(:poetry_content) { create(:poetry_content, :with_entry) }

    it "returns a success response" do
      get poetry_contents_path, params: { token: jwt }
      expect(response).to have_http_status(200)
    end

    it "returns the expected JSON" do
      get poetry_contents_path, params: { token: jwt }
      entry = json[0]
      expect(entry["entryDate"]).to eq poetry_content.journal_entry.entry_date.to_s
      expect(entry.key?("id")).to be true
      expect(entry.key?("journalEntryId")).to be true
      expect(entry["title"]).to eq poetry_content.title
      expect(entry["poem"]).to eq poetry_content.poem
    end
  end

  describe "GET /poetry_contents/:id" do
    let!(:poetry_content) { create(:poetry_content, :with_entry) }

    it "returns a success response" do
      get poetry_content_path(poetry_content.id), params: { token: jwt }
      expect(response).to be_successful
    end

    it "returns the expected JSON" do
      get poetry_content_path(poetry_content.id), params: { token: jwt }
      expect(json["entryDate"]).to eq poetry_content.journal_entry.entry_date.to_s
      expect(json.key?("id")).to be true
      expect(json["journalEntryId"]).to eq poetry_content.journal_entry.id
      expect(json["title"]).to eq poetry_content.title
      expect(json["poem"]).to eq poetry_content.poem
    end
  end

  describe "POST /poetry_contents" do
    context "with valid params" do
      it "creates a new PoetryContent" do
        expect do
          post poetry_contents_path, params: { poetry_content: valid_attributes, token: jwt }
        end.to change(PoetryContent, :count).by(1)
      end

      it "renders a JSON response with the new poetry_content" do
        post poetry_contents_path, params: { poetry_content: valid_attributes, token: jwt }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(%r{application/json}i)
        expect(response.location).to eq(poetry_content_url(PoetryContent.last))
      end

      it "returns the expected JSON" do
        post poetry_contents_path, params: { poetry_content: valid_attributes, token: jwt }
        expect(json.key?("id")).to be true
        expect(json.key?("journalEntryId")).to be true
        expect(json["entryDate"]).to eq valid_attributes[:journal_entry_attributes][:entry_date].to_s
        expect(json["title"]).to eq valid_attributes[:title]
        expect(json["poem"]).to eq valid_attributes[:poem]
      end
    end

    context "with invalid params" do
      describe "when missing poetry entry data" do
        it "renders a JSON response with errors for the new poetry_content" do
          post poetry_contents_path, params: { poetry_content: invalid_attributes, token: jwt }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
        end
      end

      describe "when missing journal_entry_attributes" do
        it "renders a JSON response with errors for the new poetry_content" do
          attributes = valid_attributes.except(:journal_entry_attributes)
          post poetry_contents_path, params: { poetry_content: attributes, token: jwt }
          expect(response).to have_http_status(:bad_request)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/param is missing/i)
        end
      end

      describe "when missing which journal to add it to" do
        it "renders a JSON response with errors for the new poetry_content" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: nil })
          post poetry_contents_path, params: { poetry_content: attributes, token: jwt }
          expect(response).to have_http_status(:bad_request)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/value is empty/i)
        end
      end

      describe "when trying to add to the wrong journal type" do
        let(:prof_dev_journal) { create(:journal, :professional_development) }

        it "renders a JSON response with errors for the new poetry_content" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: prof_dev_journal.id, entry_date: Faker::Date.between(from: 2.days.ago, to: Date.today) })
          post poetry_contents_path, params: { poetry_content: attributes, token: jwt }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/wrong journal entry type/i)
        end
      end
    end
  end

  describe "PUT /poetry_content/:id" do
    let!(:poetry_content) { create(:poetry_content, :with_entry) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:poetry_content).merge(journal_entry_attributes: { journal_id: poetry_content.journal_entry.journal_id, entry_date: Faker::Date.between(from: 2.days.ago, to: Date.today) }) }

      it "updates the requested poetry_content" do
        put poetry_content_path(poetry_content.id), params: { poetry_content: new_attributes, token: jwt }
        poetry_content.reload
        expect(poetry_content.journal_entry.entry_date).to eq(new_attributes[:journal_entry_attributes][:entry_date])
        expect(poetry_content.title).to eq(new_attributes[:title])
        expect(poetry_content.poem).to eq(new_attributes[:poem])
      end

      it "renders a JSON response with the poetry_content" do
        put poetry_content_path(poetry_content.id), params: { poetry_content: new_attributes, token: jwt }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(%r{application/json}i)
      end

      it "returns the expected JSON" do
        put poetry_content_path(poetry_content.id), params: { poetry_content: new_attributes, token: jwt }
        expect(json.key?("id")).to be true
        expect(json.key?("journalEntryId")).to be true
        expect(json["entryDate"]).to eq new_attributes[:journal_entry_attributes][:entry_date].to_s
        expect(json["title"]).to eq new_attributes[:title]
        expect(json["poem"]).to eq new_attributes[:poem]
      end

      describe "when missing journal_entry_attributes" do
        it "does not update the requested poetry_content" do
          expect { put poetry_content_path(poetry_content.id), params: { poetry_content: new_attributes, token: jwt } }.to_not change {
            poetry_content.journal_entry.id
          }
        end
      end

      describe "when moving it to a journal of the correct type" do
        let(:poetry_journal) { create(:journal, :poetry) }

        it "moves the entry to that journal" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: poetry_journal.id, entry_date: Faker::Date.between(from: 2.days.ago, to: Date.today) })
          put poetry_content_path(poetry_content.id), params: { poetry_content: attributes, token: jwt }
          poetry_content.reload
          expect(poetry_content.journal_entry.journal.id).to eq(poetry_journal.id)
        end
      end
    end

    context "with invalid params" do
      describe "when missing poetry entry data" do
        it "renders a JSON response with errors for the new poetry_content" do
          put poetry_content_path(poetry_content.id), params: { poetry_content: invalid_attributes, token: jwt }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
        end
      end

      describe "when trying to update it to a nil journal" do
        it "renders a JSON response with errors for the new poetry_content" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: nil })
          put poetry_content_path(poetry_content.id), params: { poetry_content: attributes, token: jwt }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/must exist/i)
        end
      end

      describe "when trying to move it to the wrong journal type" do
        let(:prof_dev_journal) { create(:journal, :professional_development) }

        it "renders a JSON response with errors for the new poetry_content" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: prof_dev_journal.id, entry_date: Faker::Date.between(from: 2.days.ago, to: Date.today) })
          put poetry_content_path(poetry_content.id), params: { poetry_content: attributes, token: jwt }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/wrong journal entry type/i)
        end
      end
    end
  end

  describe "DELETE /poetry_content/:id" do
    let!(:poetry_content) { create(:poetry_content, :with_entry) }

    it "destroys the requested poetry_content" do
      expect do
        delete poetry_content_path(poetry_content.id), params: { token: jwt }
      end.to change(PoetryContent, :count).by(-1)
    end
  end
end
