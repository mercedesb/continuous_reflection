# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JournalsController, type: :controller do
  before do
    request.accept = "application/json"
  end

  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }

  let(:valid_attributes) { attributes_for(:journal).merge!(user_id: current_user.id) }

  let(:invalid_attributes) do
    {
      name: '',
      user_id: current_user.id
    }
  end

  describe "GET #index" do
    let!(:journal) { create(:journal) }

    it "returns a success response" do
      get :index, params: { token: jwt }
      expect(response).to be_successful
    end

    it "assigns @journals" do
      get :index, params: { token: jwt }
      expect(subject.view_assigns["journals"]).to eq([journal])
    end
  end

  describe "GET #show" do
    let!(:journal) { create(:journal) }

    it "returns a success response" do
      get :show, params: { id: journal.to_param, token: jwt }
      expect(response).to be_successful
    end

    it "assigns @journal" do
      get :show, params: { id: journal.to_param, token: jwt }
      expect(subject.view_assigns["journal"]).to eq(journal)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "returns a success response" do
        post :create, params: { journal: valid_attributes, token: jwt }
        expect(response).to be_successful
      end

      it "assigns @journal" do
        post :create, params: { journal: valid_attributes, token: jwt }
        expect(subject.view_assigns["journal"]).to_not be_nil
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        post :create, params: { journal: invalid_attributes, token: jwt }
        expect(response).to_not be_successful
      end
    end
  end

  describe "PUT #update" do
    let!(:journal) { create(:journal) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:journal) }

      it "returns a success response" do
        put :update, params: { id: journal.to_param, journal: new_attributes, token: jwt }
        expect(response).to be_successful
      end

      it "assigns @journal" do
        put :update, params: { id: journal.to_param, journal: new_attributes, token: jwt }
        journal.reload
        expect(subject.view_assigns["journal"]).to eq(journal)
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        put :update, params: { id: journal.to_param, journal: invalid_attributes, token: jwt }
        expect(response).to_not be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:journal) { create(:journal) }

    it "returns a success response" do
      delete :destroy, params: { id: journal.to_param, token: jwt }
      expect(response).to be_successful
    end
  end
end
