# frozen_string_literal: true

class DashboardComponentsController < ApplicationController
  before_action :set_dashboard_component, only: %i[show update destroy]

  # GET /dashboard_components
  # GET /dashboard_components.json
  def index
    @dashboard_components = DashboardComponent.joins(:dashboard).where('dashboards.user': current_user)
  end

  # GET /dashboard_components/1
  # GET /dashboard_components/1.json
  def show
    @dashboard_component = DashboardComponent.joins(:dashboard).where('dashboards.user': current_user).find(params[:id])
  end

  # POST /dashboard_components
  # POST /dashboard_components.json
  def create
    dashboard = Dashboard.find_or_create_by(user_id: current_user.id)
    @dashboard_component = DashboardComponent.new(dashboard_component_params.merge(dashboard_id: dashboard.id))

    if @dashboard_component.save
      render :show, status: :created, location: @dashboard_component
    else
      render json: @dashboard_component.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /dashboard_components/1
  # PATCH/PUT /dashboard_components/1.json
  def update
    if @dashboard_component.update(dashboard_component_params)
      render :show, status: :ok, location: @dashboard_component
    else
      render json: @dashboard_component.errors, status: :unprocessable_entity
    end
  end

  # DELETE /dashboard_components/1
  # DELETE /dashboard_components/1.json
  def destroy
    @dashboard_component.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dashboard_component
    @dashboard_component = DashboardComponent.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dashboard_component_params
    params.fetch(:dashboard_component, {}).permit(:journal_id, :component_type, :position, :dashboard_id)
  end
end
