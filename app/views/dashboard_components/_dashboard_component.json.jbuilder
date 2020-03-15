# frozen_string_literal: true

json.id dashboard_component.id
json.componentType dashboard_component.component_type
json.position dashboard_component.position
json.journals dashboard_component.journals do |journal|
  json.id journal.id
end
json.createdAt dashboard_component.created_at
json.updatedAt dashboard_component.updated_at
json.url dashboard_component_url(dashboard_component, format: :json)
