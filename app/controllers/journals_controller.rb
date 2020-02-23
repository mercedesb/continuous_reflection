# frozen_string_literal: true

class JournalsController < ApplicationController
  before_action :set_journal, only: %i[show update destroy]

  # GET /journals
  # GET /journals.json
  def index
    @journals = Journal.where(user: current_user)
  end

  # GET /journals/1
  # GET /journals/1.json
  def show
    @journal = Journal.where(user: current_user).find(params[:id])
  end

  # POST /journals
  # POST /journals.json
  def create
    @journal = Journal.new(journal_params.merge(user_id: current_user.id))
    if @journal.save
      render :show, status: :created, location: @journal
    else
      render json: @journal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /journals/1
  # PATCH/PUT /journals/1.json
  def update
    if @journal.update(journal_params)
      render :show, status: :ok, location: @journal
    else
      render json: @journal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /journals/1
  # DELETE /journals/1.json
  def destroy
    @journal.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_journal
    @journal = Journal.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def journal_params
    params.fetch(:journal, {}).permit(:name, :template)
  end
end
