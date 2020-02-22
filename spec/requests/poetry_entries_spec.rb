# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "PoetryEntries", type: :request do
  let(:headers) do
    {
      'ACCEPT' => 'application/json',     # This is what Rails 4 accepts
      'HTTP_ACCEPT' => 'application/json' # This is what Rails 3 accepts
    }
  end

  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }
  let(:json) { JSON.parse(response.body) }

  let(:journal) { create(:journal, :poetry) }

  let(:valid_attributes) { attributes_for(:poetry_entry).merge!(journal_entry_attributes: { journal_id: journal.id }) }
  let(:invalid_attributes) { attributes_for(:poetry_entry).merge!(title: nil).merge!(journal_entry_attributes: { journal_id: journal.id }) }

  describe "GET /poetry_entries" do
    let!(:poetry_entry) { create(:poetry_entry) }

    it "returns a success response" do
      get poetry_entries_path, params: { token: jwt }, headers: headers
      expect(response).to have_http_status(200)
    end

    it "returns the expected JSON" do
      get poetry_entries_path, params: { token: jwt }, headers: headers
      entry = json[0]
      expect(entry.key?("id")).to be true
      expect(entry["title"]).to eq poetry_entry.title
      expect(entry["poem"]).to eq poetry_entry.poem
    end
  end

  describe "GET /poetry_entries/:id" do
    let!(:poetry_entry) { create(:poetry_entry) }

    it "returns a success response" do
      get poetry_entry_path(poetry_entry.id), params: { token: jwt }, headers: headers
      expect(response).to be_successful
    end

    it "returns the expected JSON" do
      get poetry_entry_path(poetry_entry.id), params: { token: jwt }, headers: headers
      expect(json.key?("id")).to be true
      expect(json["title"]).to eq poetry_entry.title
      expect(json["poem"]).to eq poetry_entry.poem
    end
  end

  describe "POST /poetry_entries" do
    context "with valid params" do
      it "creates a new PoetryEntry" do
        expect do
          post poetry_entries_path, params: { poetry_entry: valid_attributes, token: jwt }, headers: headers
        end.to change(PoetryEntry, :count).by(1)
      end

      it "renders a JSON response with the new poetry_entry" do
        post poetry_entries_path, params: { poetry_entry: valid_attributes, token: jwt }, headers: headers
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(%r{application/json}i)
        expect(response.location).to eq(poetry_entry_url(PoetryEntry.last))
      end

      it "returns the expected JSON" do
        post poetry_entries_path, params: { poetry_entry: valid_attributes, token: jwt }, headers: headers
        expect(json.key?("id")).to be true
        expect(json["title"]).to eq valid_attributes[:title]
        expect(json["poem"]).to eq valid_attributes[:poem]
      end
    end

    context "with invalid params" do
      describe "when missing poetry entry data" do
        it "renders a JSON response with errors for the new poetry_entry" do
          post poetry_entries_path, params: { poetry_entry: invalid_attributes, token: jwt }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
        end
      end

      describe "when missing journal_entry_attributes" do
        it "renders a JSON response with errors for the new poetry_entry" do
          attributes = valid_attributes.except(:journal_entry_attributes)
          post poetry_entries_path, params: { poetry_entry: attributes, token: jwt }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/journal can't be blank/i)
        end
      end

      describe "when missing which journal to add it to" do
        it "renders a JSON response with errors for the new poetry_entry" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: nil })
          post poetry_entries_path, params: { poetry_entry: attributes, token: jwt }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/must exist/i)
        end
      end

      describe "when trying to add to the wrong journal type" do
        let(:prof_dev_journal) { create(:journal, :professional_development) }

        it "renders a JSON response with errors for the new poetry_entry" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: prof_dev_journal.id })
          post poetry_entries_path, params: { poetry_entry: attributes, token: jwt }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/wrong journal entry type/i)
        end
      end
    end
  end

  describe "PUT /poetry_entry/:id" do
    let!(:poetry_entry) { create(:poetry_entry) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:poetry_entry) }

      it "updates the requested poetry_entry" do
        put poetry_entry_path(poetry_entry.id), params: { poetry_entry: new_attributes, token: jwt }, headers: headers
        poetry_entry.reload
        expect(poetry_entry.title).to eq(new_attributes[:title])
        expect(poetry_entry.poem).to eq(new_attributes[:poem])
      end

      it "renders a JSON response with the poetry_entry" do
        put poetry_entry_path(poetry_entry.id), params: { poetry_entry: new_attributes, token: jwt }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(%r{application/json}i)
      end

      it "returns the expected JSON" do
        put poetry_entry_path(poetry_entry.id), params: { poetry_entry: new_attributes, token: jwt }, headers: headers
        expect(json.key?("id")).to be true
        expect(json["title"]).to eq new_attributes[:title]
        expect(json["poem"]).to eq new_attributes[:poem]
      end

      describe "when missing journal_entry_attributes" do
        it "does not update the requested poetry_entry" do
          expect { put poetry_entry_path(poetry_entry.id), params: { poetry_entry: new_attributes, token: jwt }, headers: headers }.to_not change {
            poetry_entry.journal_entry.id
          }
        end
      end

      describe "when moving it to a journal of the correct type" do
        let(:poetry_journal) { create(:journal, :poetry) }

        it "moves the entry to that journal" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: poetry_journal.id })
          put poetry_entry_path(poetry_entry.id), params: { poetry_entry: attributes, token: jwt }, headers: headers
          poetry_entry.reload
          expect(poetry_entry.journal_entry.journal.id).to eq(poetry_journal.id)
        end
      end
    end

    context "with invalid params" do
      describe "when missing poetry entry data" do
        it "renders a JSON response with errors for the new poetry_entry" do
          put poetry_entry_path(poetry_entry.id), params: { poetry_entry: invalid_attributes, token: jwt }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
        end
      end

      describe "when trying to update it to a nil journal" do
        it "renders a JSON response with errors for the new poetry_entry" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: nil })
          put poetry_entry_path(poetry_entry.id), params: { poetry_entry: attributes, token: jwt }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/must exist/i)
        end
      end

      describe "when trying to move it to the wrong journal type" do
        let(:prof_dev_journal) { create(:journal, :professional_development) }

        it "renders a JSON response with errors for the new poetry_entry" do
          attributes = valid_attributes.merge(journal_entry_attributes: { journal_id: prof_dev_journal.id })
          put poetry_entry_path(poetry_entry.id), params: { poetry_entry: attributes, token: jwt }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(%r{application/json}i)
          expect(response.body).to match(/wrong journal entry type/i)
        end
      end
    end
  end

  describe "DELETE /poetry_entry/:id" do
    let!(:poetry_entry) { create(:poetry_entry) }

    it "destroys the requested poetry_entry" do
      expect do
        delete poetry_entry_path(poetry_entry.id), params: { token: jwt }, headers: headers
      end.to change(PoetryEntry, :count).by(-1)
    end
  end
end
