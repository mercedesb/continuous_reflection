# frozen_string_literal: true

json.id dashboard.id
json.components dashboard.dashboard_components.order(:position) do |component|
  json.partial! "dashboard_components/dashboard_component", dashboard_component: component
end
json.userId dashboard.user_id
json.createdAt dashboard.created_at
json.updatedAt dashboard.updated_at
json.url dashboard_url(dashboard, format: :json)
