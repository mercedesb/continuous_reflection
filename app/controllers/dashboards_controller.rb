# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :set_dashboard, only: %i[show update destroy]

  # GET /dashboards
  # GET /dashboards.json
  def index
    @dashboards = Dashboard.where(user: current_user)
  end

  # GET /dashboards/1
  # GET /dashboards/1.json
  def show
    @dashboard = Dashboard.where(user: current_user).find(params[:id])
  end

  # POST /dashboards
  # POST /dashboards.json
  def create
    @dashboard = Dashboard.new(dashboard_params.merge(user_id: current_user.id))

    if @dashboard.save
      render :show, status: :created, location: @dashboard
    else
      render json: @dashboard.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /dashboards/1
  # PATCH/PUT /dashboards/1.json
  def update
    if @dashboard.update(dashboard_params)
      render :show, status: :ok, location: @dashboard
    else
      render json: @dashboard.errors, status: :unprocessable_entity
    end
  end

  # DELETE /dashboards/1
  # DELETE /dashboards/1.json
  def destroy
    @dashboard.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dashboard
    @dashboard = Dashboard.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dashboard_params
    params.fetch(:dashboard, {}).permit(:user_id)
  end
end
