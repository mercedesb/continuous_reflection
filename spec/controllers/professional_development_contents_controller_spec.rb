# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfessionalDevelopmentContentsController, type: :controller do
  before do
    request.accept = "application/json"
  end

  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }

  let(:journal) { create(:journal, :professional_development) }

  let(:valid_attributes) { attributes_for(:professional_development_content).merge!(journal_entry_attributes: { journal_id: journal.id }) }
  let(:invalid_attributes) { attributes_for(:professional_development_content).merge!(title: nil).merge!(journal_entry_attributes: { journal_id: journal.id }) }

  describe "GET #index" do
    let!(:professional_development_content) { create(:professional_development_content) }

    it "returns a success response" do
      get :index, params: { token: jwt }
      expect(response).to be_successful
    end

    it "assigns @professional_development_contents" do
      get :index, params: { token: jwt }
      expect(subject.view_assigns["professional_development_contents"]).to eq([professional_development_content])
    end
  end

  describe "GET #show" do
    let!(:professional_development_content) { create(:professional_development_content) }

    it "returns a success response" do
      get :show, params: { id: professional_development_content.to_param, token: jwt }
      expect(response).to be_successful
    end

    it "assigns @professional_development_content" do
      get :show, params: { id: professional_development_content.to_param, token: jwt }
      expect(subject.view_assigns["professional_development_content"]).to eq(professional_development_content)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "returns a success response" do
        post :create, params: { professional_development_content: valid_attributes, token: jwt }
        expect(response).to be_successful
      end

      it "assigns @professional_development_content" do
        post :create, params: { professional_development_content: valid_attributes, token: jwt }
        expect(subject.view_assigns["professional_development_content"]).to_not be_nil
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        post :create, params: { professional_development_content: invalid_attributes, token: jwt }
        expect(response).to_not be_successful
      end
    end
  end

  describe "PUT #update" do
    let!(:professional_development_content) { create(:professional_development_content) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:professional_development_content) }

      it "returns a success response" do
        put :update, params: { id: professional_development_content.to_param, professional_development_content: new_attributes, token: jwt }
        expect(response).to be_successful
      end

      it "assigns @professional_development_content" do
        put :update, params: { id: professional_development_content.to_param, professional_development_content: new_attributes, token: jwt }
        professional_development_content.reload
        expect(subject.view_assigns["professional_development_content"]).to eq(professional_development_content)
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        put :update, params: { id: professional_development_content.to_param, professional_development_content: invalid_attributes, token: jwt }
        expect(response).to_not be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:professional_development_content) { create(:professional_development_content) }

    it "returns a success response" do
      delete :destroy, params: { id: professional_development_content.to_param, token: jwt }
      expect(response).to be_successful
    end
  end
end
