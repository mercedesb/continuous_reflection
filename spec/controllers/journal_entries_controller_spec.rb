# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JournalEntriesController, type: :controller do
  before do
    request.accept = "application/json"
  end

  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }

  describe "GET #index" do
    let(:journal) { create(:journal, user: current_user) }
    let!(:journal_entry) { create(:journal_entry, journal: journal) }

    it "returns a success response" do
      get :index, params: { token: jwt }
      expect(response).to be_successful
    end

    it "assigns @journal_entries" do
      get :index, params: { token: jwt }
      expect(subject.view_assigns["journal_entries"]).to eq([journal_entry])
    end
  end

  describe "GET #show" do
    let(:journal) { create(:journal, user: current_user) }
    let!(:journal_entry) { create(:journal_entry, journal: journal) }

    it "returns a success response" do
      get :show, params: { id: journal_entry.to_param, token: jwt }
      expect(response).to be_successful
    end

    it "assigns @journal_entry" do
      get :show, params: { id: journal_entry.to_param, token: jwt }
      expect(subject.view_assigns["journal_entry"]).to eq(journal_entry)
    end
  end
end
