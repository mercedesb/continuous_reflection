# frozen_string_literal: true

class ProfessionalDevelopmentContentsController < ApplicationController
  before_action :set_professional_development_content, only: %i[show update destroy]

  # GET /professional_development_contents
  # GET /professional_development_contents.json
  def index
    @professional_development_contents = ProfessionalDevelopmentContent.all
  end

  # GET /professional_development_contents/1
  # GET /professional_development_contents/1.json
  def show; end

  # POST /professional_development_contents
  # POST /professional_development_contents.json
  def create
    @professional_development_content = ProfessionalDevelopmentContent.new(professional_development_content_create_params)

    if @professional_development_content.save
      render :show, status: :created, location: @professional_development_content
    else
      render json: @professional_development_content.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /professional_development_contents/1
  # PATCH/PUT /professional_development_contents/1.json
  def update
    if @professional_development_content.update(professional_development_content_params)
      render :show, status: :ok, location: @professional_development_content
    else
      render json: @professional_development_content.errors, status: :unprocessable_entity
    end
  end

  # DELETE /professional_development_contents/1
  # DELETE /professional_development_contents/1.json
  def destroy
    @professional_development_content.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_professional_development_content
    @professional_development_content = ProfessionalDevelopmentContent.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def professional_development_content_params
    params.fetch(:professional_development_content, {}).permit(:title, :mood, :today_i_learned, :goal_progress, :celebrations, journal_entry_attributes: %i[journal_id])
  end

  def professional_development_content_create_params
    permitted_params = professional_development_content_params
    permitted_params.require(:journal_entry_attributes).require(:journal_id)
    permitted_params
  end
end
