# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PoetryContentsController, type: :controller do
  before do
    request.accept = "application/json"
  end

  let(:current_user) { create(:user) }
  let(:jwt) { AuthToken.encode(current_user.username) }

  let(:journal) { create(:journal, :poetry) }

  let(:valid_attributes) { attributes_for(:poetry_content).merge!(journal_entry_attributes: { journal_id: journal.id }) }
  let(:invalid_attributes) { attributes_for(:poetry_content).merge!(title: nil).merge!(journal_entry_attributes: { journal_id: journal.id }) }

  describe "GET #index" do
    let!(:poetry_content) { create(:poetry_content) }

    it "returns a success response" do
      get :index, params: { token: jwt }
      expect(response).to be_successful
    end

    it "assigns @poetry_contents" do
      get :index, params: { token: jwt }
      expect(subject.view_assigns["poetry_contents"]).to eq([poetry_content])
    end
  end

  describe "GET #show" do
    let!(:poetry_content) { create(:poetry_content) }

    it "returns a success response" do
      get :show, params: { id: poetry_content.to_param, token: jwt }
      expect(response).to be_successful
    end

    it "assigns @poetry_content" do
      get :show, params: { id: poetry_content.to_param, token: jwt }
      expect(subject.view_assigns["poetry_content"]).to eq(poetry_content)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "returns a success response" do
        post :create, params: { poetry_content: valid_attributes, token: jwt }
        expect(response).to be_successful
      end

      it "assigns @poetry_content" do
        post :create, params: { poetry_content: valid_attributes, token: jwt }
        expect(subject.view_assigns["poetry_content"]).to_not be_nil
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        post :create, params: { poetry_content: invalid_attributes, token: jwt }
        expect(response).to_not be_successful
      end
    end
  end

  describe "PUT #update" do
    let!(:poetry_content) { create(:poetry_content) }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:poetry_content) }

      it "returns a success response" do
        put :update, params: { id: poetry_content.to_param, poetry_content: new_attributes, token: jwt }
        expect(response).to be_successful
      end

      it "assigns @poetry_content" do
        put :update, params: { id: poetry_content.to_param, poetry_content: new_attributes, token: jwt }
        poetry_content.reload
        expect(subject.view_assigns["poetry_content"]).to eq(poetry_content)
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        put :update, params: { id: poetry_content.to_param, poetry_content: invalid_attributes, token: jwt }
        expect(response).to_not be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:poetry_content) { create(:poetry_content) }

    it "returns a success response" do
      delete :destroy, params: { id: poetry_content.to_param, token: jwt }
      expect(response).to be_successful
    end
  end
end
