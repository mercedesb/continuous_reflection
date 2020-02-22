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

  let(:valid_attributes) { attributes_for(:journal).merge!(user_id: current_user.id) }

  let(:invalid_attributes) do
    {
      name: '',
      user_id: current_user.id
    }
  end

  describe "GET /journals" do
    let!(:journal) { create(:journal) }

    it "returns a success response" do
      get journals_path, params: { token: jwt }, headers: headers
      expect(response).to have_http_status(200)
    end

    it "returns the expected JSON" do
      get journals_path, params: { token: jwt }, headers: headers
      entry = json[0]
      expect(entry.key?("id")).to be true
      expect(entry["name"]).to eq journal.name
      expect(entry["user_id"]).to eq journal.user_id
    end
  end

  describe "GET /journals/:id" do
    let!(:journal) { create(:journal) }

    it "returns a success response" do
      get journal_path(journal.id), params: { token: jwt }, headers: headers
      expect(response).to be_successful
    end

    it "returns the expected JSON" do
      get journal_path(journal.id), params: { token: jwt }, headers: headers
      expect(json.key?("id")).to be true
      expect(json["name"]).to eq journal.name
      expect(json["user_id"]).to eq journal.user_id
    end
  end

  describe "POST /journals" do
    context "with valid params" do
      it "creates a new Journal" do
        expect do
          post journals_path, params: { journal: valid_attributes, token: jwt }, headers: headers
        end.to change(Journal, :count).by(1)
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
        expect(json["user_id"]).to eq valid_attributes[:user_id]
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
    let!(:journal) { create(:journal) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:journal).merge!(user_id: current_user.id) }

      it "updates the requested journal" do
        put journal_path(journal.id), params: { journal: new_attributes, token: jwt }, headers: headers
        journal.reload
        expect(journal.name).to eq(new_attributes[:name])
        expect(journal.user_id).to eq(new_attributes[:user_id])
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
