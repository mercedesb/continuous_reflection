# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Journals", type: :request do
  let(:headers) do
    {
      'ACCEPT' => 'application/json',     # This is what Rails 4 accepts
      'HTTP_ACCEPT' => 'application/json' # This is what Rails 3 accepts
    }
  end

  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }
  let(:json) { JSON.parse(response.body) }

  let(:valid_attributes) { attributes_for(:journal) }

  let(:invalid_attributes) do
    {
      name: ''
    }
  end

  describe "GET /journals" do
    it "returns a success response" do
      get journals_path, params: { token: jwt }, headers: headers
      expect(response).to have_http_status(200)
    end

    describe "when the logged in user has journal(s)" do
      let!(:journal) { create(:journal, user: current_user) }
      let!(:journal_2) { create(:journal) }
      it "only returns journals for the current_user" do
        get journals_path, params: { token: jwt }, headers: headers
        expect(json.pluck("id")).to match_array([journal.id])
      end

      it "returns the expected JSON" do
        get journals_path, params: { token: jwt }, headers: headers
        ret_journal = json[0]
        expect(ret_journal.key?("id")).to be true
        expect(ret_journal["name"]).to eq journal.name
        expect(ret_journal["userId"]).to eq journal.user_id
      end
    end

    describe "when the logged in user does not have any journal_entries" do
      let!(:journal_entry) { create(:journal_entry) }

      it "returns an empty array" do
        get journals_path, params: { token: jwt }, headers: headers
        expect(json).to eq []
      end
    end
  end

  describe "GET /journals/:id" do
    describe "when the requested entry belongs to the logged in user" do
      let!(:journal) { create(:journal, user: current_user) }

      it "returns a success response" do
        get journal_path(journal.id), params: { token: jwt }, headers: headers
        expect(response).to be_successful
      end

      it "returns the expected JSON" do
        get journal_path(journal.id), params: { token: jwt }, headers: headers
        expect(json.key?("id")).to be true
        expect(json["name"]).to eq journal.name
        expect(json["template"]).to eq journal.template
        expect(json["journalEntries"]).to eq journal.journal_entries.map { |e| { id: e.id } }
        expect(json["userId"]).to eq journal.user_id
      end

      describe "when the journal has journal_entries" do
        let!(:entry) { create(:journal_entry, journal: journal) }

        it "returns the expected JSON" do
          get journal_path(journal.id), params: { token: jwt }, headers: headers
          expect(json.key?("id")).to be true
          expect(json["name"]).to eq journal.name
          expect(json["template"]).to eq journal.template
          expect(json["journalEntries"]).to eq journal.journal_entries.map { |e| { id: e.id, title: e.content.title, entryDate: e.entry_date.to_s }.stringify_keys }
          expect(json["userId"]).to eq journal.user_id
        end
      end
    end

    describe "when the requested entry does not belong to the logged in user" do
      let!(:journal) { create(:journal) }

      it "returns a not found response" do
        get journal_path(journal.id), params: { token: jwt }, headers: headers
        expect(response).to_not be_successful
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /journals" do
    context "with valid params" do
      it "creates a new Journal" do
        expect do
          post journals_path, params: { journal: valid_attributes, token: jwt }, headers: headers
        end.to change(Journal, :count).by(1)
      end

      it "associates the new journal with the logged in user" do
        post journals_path, params: { journal: valid_attributes, token: jwt }, headers: headers
        expect(Journal.all.first.user).to eq(current_user)
      end

      it "renders a JSON response with the new journal" do
        post journals_path, params: { journal: valid_attributes, token: jwt }, headers: headers
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(%r{application/json}i)
        expect(response.location).to eq(journal_url(Journal.last))
      end

      it "returns the expected JSON" do
        post journals_path, params: { journal: valid_attributes, token: jwt }, headers: headers
        expect(json.key?("id")).to be true
        expect(json["name"]).to eq valid_attributes[:name]
        expect(json["template"]).to eq valid_attributes[:template]
        expect(json["journalEntries"]).to eq []
        expect(json["userId"]).to eq current_user.id
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new journal" do
        post journals_path, params: { journal: invalid_attributes, token: jwt }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(%r{application/json}i)
      end
    end
  end

  describe "PUT /journal/:id" do
    let!(:journal) { create(:journal, user: current_user) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:journal) }

      it "updates the requested journal" do
        put journal_path(journal.id), params: { journal: new_attributes, token: jwt }, headers: headers
        journal.reload
        expect(journal.name).to eq(new_attributes[:name])
        expect(journal.user_id).to eq(current_user.id)
      end

      it "renders a JSON response with the journal" do
        put journal_path(journal.id), params: { journal: new_attributes, token: jwt }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(%r{application/json}i)
      end

      it "returns the expected JSON" do
        put journal_path(journal.id), params: { journal: new_attributes, token: jwt }, headers: headers
        expect(json.key?("id")).to be true
        expect(json["name"]).to eq new_attributes[:name]
        expect(json["template"]).to eq new_attributes[:template]
        expect(json.key?("journalEntries")).to be true
        expect(json["user_id"]).to eq new_attributes[:user_id]
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the journal" do
        put journal_path(journal.id), params: { journal: invalid_attributes, token: jwt }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(%r{application/json}i)
      end
    end
  end

  describe "DELETE /journal/:id" do
    let!(:journal) { create(:journal) }

    it "destroys the requested journal" do
      expect do
        delete journal_path(journal.id), params: { token: jwt }, headers: headers
      end.to change(Journal, :count).by(-1)
    end
  end
end
