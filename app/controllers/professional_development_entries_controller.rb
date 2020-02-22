# frozen_string_literal: true

class ProfessionalDevelopmentEntriesController < ApplicationController
  before_action :set_professional_development_entry, only: %i[show update destroy]

  # GET /professional_development_entries
  # GET /professional_development_entries.json
  def index
    @professional_development_entries = ProfessionalDevelopmentEntry.all
  end

  # GET /professional_development_entries/1
  # GET /professional_development_entries/1.json
  def show; end

  # POST /professional_development_entries
  # POST /professional_development_entries.json
  def create
    @professional_development_entry = ProfessionalDevelopmentEntry.new(professional_development_entry_params)

    if @professional_development_entry.save
      render :show, status: :created, location: @professional_development_entry
    else
      render json: @professional_development_entry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /professional_development_entries/1
  # PATCH/PUT /professional_development_entries/1.json
  def update
    if @professional_development_entry.update(professional_development_entry_params)
      render :show, status: :ok, location: @professional_development_entry
    else
      render json: @professional_development_entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /professional_development_entries/1
  # DELETE /professional_development_entries/1.json
  def destroy
    @professional_development_entry.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_professional_development_entry
    @professional_development_entry = ProfessionalDevelopmentEntry.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def professional_development_entry_params
    params.fetch(:professional_development_entry, {}).permit(:title, :mood, :today_i_learned, :goal_progress, :celebrations)
  end
end
