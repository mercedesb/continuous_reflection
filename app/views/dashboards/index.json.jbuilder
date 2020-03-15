# frozen_string_literal: true

if @dashboard.present?
  json.partial! "dashboards/dashboard", dashboard: @dashboard
else
  json.components []
end
