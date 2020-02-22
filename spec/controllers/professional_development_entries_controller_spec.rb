# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfessionalDevelopmentEntriesController, type: :controller do
  before do
    request.accept = "application/json"
  end

  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }

  let(:valid_attributes) { attributes_for(:professional_development_entry) }
  let(:invalid_attributes) { attributes_for(:professional_development_entry).merge!(title: nil) }

  describe "GET #index" do
    let!(:professional_development_entry) { create(:professional_development_entry) }

    it "returns a success response" do
      get :index, params: { token: jwt }
      expect(response).to be_successful
    end

    it "assigns @professional_development_entries" do
      get :index, params: { token: jwt }
      expect(subject.view_assigns["professional_development_entries"]).to eq([professional_development_entry])
    end
  end

  describe "GET #show" do
    let!(:professional_development_entry) { create(:professional_development_entry) }

    it "returns a success response" do
      get :show, params: { id: professional_development_entry.to_param, token: jwt }
      expect(response).to be_successful
    end

    it "assigns @professional_development_entry" do
      get :show, params: { id: professional_development_entry.to_param, token: jwt }
      expect(subject.view_assigns["professional_development_entry"]).to eq(professional_development_entry)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "returns a success response" do
        post :create, params: { professional_development_entry: valid_attributes, token: jwt }
        expect(response).to be_successful
      end

      it "assigns @professional_development_entry" do
        post :create, params: { professional_development_entry: valid_attributes, token: jwt }
        expect(subject.view_assigns["professional_development_entry"]).to_not be_nil
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        post :create, params: { professional_development_entry: invalid_attributes, token: jwt }
        expect(response).to_not be_successful
      end
    end
  end

  describe "PUT #update" do
    let!(:professional_development_entry) { create(:professional_development_entry) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:professional_development_entry) }

      it "returns a success response" do
        put :update, params: { id: professional_development_entry.to_param, professional_development_entry: new_attributes, token: jwt }
        expect(response).to be_successful
      end

      it "assigns @professional_development_entry" do
        put :update, params: { id: professional_development_entry.to_param, professional_development_entry: new_attributes, token: jwt }
        professional_development_entry.reload
        expect(subject.view_assigns["professional_development_entry"]).to eq(professional_development_entry)
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        put :update, params: { id: professional_development_entry.to_param, professional_development_entry: invalid_attributes, token: jwt }
        expect(response).to_not be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:professional_development_entry) { create(:professional_development_entry) }

    it "returns a success response" do
      delete :destroy, params: { id: professional_development_entry.to_param, token: jwt }
      expect(response).to be_successful
    end
  end
end
