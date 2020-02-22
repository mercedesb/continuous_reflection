# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "ProfessionalDevelopmentEntries", type: :request do
  let(:headers) do
    {
      'ACCEPT' => 'application/json',     # This is what Rails 4 accepts
      'HTTP_ACCEPT' => 'application/json' # This is what Rails 3 accepts
    }
  end

  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }
  let(:json) { JSON.parse(response.body) }

  let(:valid_attributes) { attributes_for(:professional_development_entry) }
  let(:invalid_attributes) { attributes_for(:professional_development_entry).merge!(title: nil) }

  describe "GET /professional_development_entries" do
    let!(:professional_development_entry) { create(:professional_development_entry) }

    it "returns a success response" do
      get professional_development_entries_path, params: { token: jwt }, headers: headers
      expect(response).to have_http_status(200)
    end

    it "returns the expected JSON" do
      get professional_development_entries_path, params: { token: jwt }, headers: headers
      entry = json[0]
      expect(entry.key?("id")).to be true
      expect(entry["title"]).to eq professional_development_entry.title
      expect(entry["mood"]).to eq professional_development_entry.mood
      expect(entry["todayILearned"]).to eq professional_development_entry.today_i_learned
      expect(entry["goalProgress"]).to eq professional_development_entry.goal_progress
      expect(entry["celebrations"]).to eq professional_development_entry.celebrations
    end
  end

  describe "GET /professional_development/entries/:id" do
    let!(:professional_development_entry) { create(:professional_development_entry) }

    it "returns a success response" do
      get professional_development_entry_path(professional_development_entry.id), params: { token: jwt }, headers: headers
      expect(response).to be_successful
    end

    it "returns the expected JSON" do
      get professional_development_entry_path(professional_development_entry.id), params: { token: jwt }, headers: headers
      expect(json.key?("id")).to be true
      expect(json["title"]).to eq professional_development_entry.title
      expect(json["mood"]).to eq professional_development_entry.mood
      expect(json["todayILearned"]).to eq professional_development_entry.today_i_learned
      expect(json["goalProgress"]).to eq professional_development_entry.goal_progress
      expect(json["celebrations"]).to eq professional_development_entry.celebrations
    end
  end

  describe "POST /professional_development_entries" do
    context "with valid params" do
      it "creates a new ProfessionalDevelopmentEntry" do
        expect do
          post professional_development_entries_path, params: { professional_development_entry: valid_attributes, token: jwt }, headers: headers
        end.to change(ProfessionalDevelopmentEntry, :count).by(1)
      end

      it "renders a JSON response with the new professional_development_entry" do
        post professional_development_entries_path, params: { professional_development_entry: valid_attributes, token: jwt }, headers: headers
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(%r{application/json}i)
        expect(response.location).to eq(professional_development_entry_url(ProfessionalDevelopmentEntry.last))
      end

      it "returns the expected JSON" do
        post professional_development_entries_path, params: { professional_development_entry: valid_attributes, token: jwt }, headers: headers
        expect(json.key?("id")).to be true
        expect(json["title"]).to eq valid_attributes[:title]
        expect(json["mood"]).to eq valid_attributes[:mood]
        expect(json["todayILearned"]).to eq valid_attributes[:today_i_learned]
        expect(json["goalProgress"]).to eq valid_attributes[:goal_progress]
        expect(json["celebrations"]).to eq valid_attributes[:celebrations]
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new professional_development_entry" do
        post professional_development_entries_path, params: { professional_development_entry: invalid_attributes, token: jwt }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(%r{application/json}i)
      end
    end
  end

  describe "PUT /professional_development_entry/:id" do
    let!(:professional_development_entry) { create(:professional_development_entry) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:professional_development_entry) }

      it "updates the requested professional_development_entry" do
        put professional_development_entry_path(professional_development_entry.id), params: { professional_development_entry: new_attributes, token: jwt }, headers: headers
        professional_development_entry.reload
        expect(professional_development_entry.title).to eq(new_attributes[:title])
        expect(professional_development_entry.mood).to eq(new_attributes[:mood])
        expect(professional_development_entry.today_i_learned).to eq(new_attributes[:today_i_learned])
        expect(professional_development_entry.goal_progress).to eq(new_attributes[:goal_progress])
        expect(professional_development_entry.celebrations).to eq(new_attributes[:celebrations])
      end

      it "renders a JSON response with the professional_development_entry" do
        put professional_development_entry_path(professional_development_entry.id), params: { professional_development_entry: new_attributes, token: jwt }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(%r{application/json}i)
      end

      it "returns the expected JSON" do
        put professional_development_entry_path(professional_development_entry.id), params: { professional_development_entry: new_attributes, token: jwt }, headers: headers
        expect(json.key?("id")).to be true
        expect(json["title"]).to eq new_attributes[:title]
        expect(json["mood"]).to eq new_attributes[:mood]
        expect(json["todayILearned"]).to eq new_attributes[:today_i_learned]
        expect(json["goalProgress"]).to eq new_attributes[:goal_progress]
        expect(json["celebrations"]).to eq new_attributes[:celebrations]
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the professional_development_entry" do
        put professional_development_entry_path(professional_development_entry.id), params: { professional_development_entry: invalid_attributes, token: jwt }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(%r{application/json}i)
      end
    end
  end

  describe "DELETE /professional_development_entry/:id" do
    let!(:professional_development_entry) { create(:professional_development_entry) }

    it "destroys the requested professional_development_entry" do
      expect do
        delete professional_development_entry_path(professional_development_entry.id), params: { token: jwt }, headers: headers
      end.to change(ProfessionalDevelopmentEntry, :count).by(-1)
    end
  end
end
