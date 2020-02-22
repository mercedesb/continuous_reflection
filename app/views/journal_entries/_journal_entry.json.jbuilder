# frozen_string_literal: true

json.id journal_entry.id
json.content_id journal_entry.content_id
json.content_type journal_entry.content_type
json.content do
  if journal_entry.content_type == ProfessionalDevelopmentContent.name
    json.partial! "professional_development_contents/professional_development_content", professional_development_content: journal_entry.content
  elsif journal_entry.content_type == PoetryContent.name
    json.partial! "poetry_contents/poetry_content", poetry_content: journal_entry.content
  end
end
json.created_at journal_entry.created_at
json.updated_at journal_entry.updated_at
json.url journal_entry_url(journal_entry, format: :json)
