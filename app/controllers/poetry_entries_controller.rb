# frozen_string_literal: true

class PoetryEntriesController < ApplicationController
  before_action :set_poetry_entry, only: %i[show update destroy]

  # GET /poetry_entries
  # GET /poetry_entries.json
  def index
    @poetry_entries = PoetryEntry.all
  end

  # GET /poetry_entries/1
  # GET /poetry_entries/1.json
  def show; end

  # POST /poetry_entries
  # POST /poetry_entries.json
  def create
    @poetry_entry = PoetryEntry.new(poetry_entry_params)

    if @poetry_entry.save
      render :show, status: :created, location: @poetry_entry
    else
      render json: @poetry_entry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /poetry_entries/1
  # PATCH/PUT /poetry_entries/1.json
  def update
    if @poetry_entry.update(poetry_entry_params)
      render :show, status: :ok, location: @poetry_entry
    else
      render json: @poetry_entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /poetry_entries/1
  # DELETE /poetry_entries/1.json
  def destroy
    @poetry_entry.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_poetry_entry
    @poetry_entry = PoetryEntry.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def poetry_entry_params
    params.fetch(:poetry_entry, {}).permit(:title, :poem)
  end
end
