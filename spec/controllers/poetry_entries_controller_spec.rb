# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PoetryEntriesController, type: :controller do
  before do
    request.accept = "application/json"
  end

  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }

  let(:journal) { create(:journal, :poetry) }

  let(:valid_attributes) { attributes_for(:poetry_entry).merge!(journal_entry_attributes: { journal_id: journal.id }) }
  let(:invalid_attributes) { attributes_for(:poetry_entry).merge!(title: nil).merge!(journal_entry_attributes: { journal_id: journal.id }) }

  describe "GET #index" do
    let!(:poetry_entry) { create(:poetry_entry) }

    it "returns a success response" do
      get :index, params: { token: jwt }
      expect(response).to be_successful
    end

    it "assigns @poetry_entries" do
      get :index, params: { token: jwt }
      expect(subject.view_assigns["poetry_entries"]).to eq([poetry_entry])
    end
  end

  describe "GET #show" do
    let!(:poetry_entry) { create(:poetry_entry) }

    it "returns a success response" do
      get :show, params: { id: poetry_entry.to_param, token: jwt }
      expect(response).to be_successful
    end

    it "assigns @poetry_entry" do
      get :show, params: { id: poetry_entry.to_param, token: jwt }
      expect(subject.view_assigns["poetry_entry"]).to eq(poetry_entry)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "returns a success response" do
        post :create, params: { poetry_entry: valid_attributes, token: jwt }
        expect(response).to be_successful
      end

      it "assigns @poetry_entry" do
        post :create, params: { poetry_entry: valid_attributes, token: jwt }
        expect(subject.view_assigns["poetry_entry"]).to_not be_nil
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        post :create, params: { poetry_entry: invalid_attributes, token: jwt }
        expect(response).to_not be_successful
      end
    end
  end

  describe "PUT #update" do
    let!(:poetry_entry) { create(:poetry_entry) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:poetry_entry) }

      it "returns a success response" do
        put :update, params: { id: poetry_entry.to_param, poetry_entry: new_attributes, token: jwt }
        expect(response).to be_successful
      end

      it "assigns @poetry_entry" do
        put :update, params: { id: poetry_entry.to_param, poetry_entry: new_attributes, token: jwt }
        poetry_entry.reload
        expect(subject.view_assigns["poetry_entry"]).to eq(poetry_entry)
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        put :update, params: { id: poetry_entry.to_param, poetry_entry: invalid_attributes, token: jwt }
        expect(response).to_not be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:poetry_entry) { create(:poetry_entry) }

    it "returns a success response" do
      delete :destroy, params: { id: poetry_entry.to_param, token: jwt }
      expect(response).to be_successful
    end
  end
end
