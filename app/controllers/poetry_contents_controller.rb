# frozen_string_literal: true

class PoetryContentsController < ApplicationController
  before_action :set_poetry_content, only: %i[show update destroy]

  # GET /poetry_contents
  # GET /poetry_contents.json
  def index
    @poetry_contents = PoetryContent.all
  end

  # GET /poetry_contents/1
  # GET /poetry_contents/1.json
  def show; end

  # POST /poetry_contents
  # POST /poetry_contents.json
  def create
    @poetry_content = PoetryContent.new(poetry_content_create_params)

    if @poetry_content.save
      render :show, status: :created, location: @poetry_content
    else
      render json: @poetry_content.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /poetry_contents/1
  # PATCH/PUT /poetry_contents/1.json
  def update
    if @poetry_content.update(poetry_content_params)
      render :show, status: :ok, location: @poetry_content
    else
      render json: @poetry_content.errors, status: :unprocessable_entity
    end
  end

  # DELETE /poetry_contents/1
  # DELETE /poetry_contents/1.json
  def destroy
    @poetry_content.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_poetry_content
    @poetry_content = PoetryContent.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def poetry_content_params
    params.fetch(:poetry_content, {}).permit(:title, :poem, journal_entry_attributes: %i[journal_id entry_date])
  end

  def poetry_content_create_params
    permitted_params = poetry_content_params
    permitted_params.require(:journal_entry_attributes).require(%i[journal_id entry_date])
    permitted_params
  end
end
