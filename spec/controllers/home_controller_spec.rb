# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: { token: jwt }
      expect(response).to be_successful
    end
  end

  describe "GET #journal_entries" do
    let(:journal) { create(:journal, user: current_user) }
    let!(:journal_entry) { create(:journal_entry, journal: journal) }

    it "returns a success response" do
      get :journal_entries, params: { token: jwt, journal_ids: [journal.id].join(",") }
      expect(response).to be_successful
    end

    it "assigns @journal_entries" do
      get :journal_entries, params: { token: jwt, journal_ids: [journal.id].join(",") }
      expect(subject.view_assigns["journal_entries"]).to eq([journal_entry])
    end
  end
end
