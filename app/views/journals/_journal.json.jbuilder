# frozen_string_literal: true

json.id journal.id
json.name journal.name
json.template journal.template
json.userId journal.user_id
json.journalEntries journal.journal_entries.order(entry_date: :desc) do |entry|
  json.id entry.id
  json.title entry.content.title
  json.entryDate entry.entry_date
end
json.createdAt journal.created_at
json.updatedAt journal.updated_at
json.url journal_url(journal, format: :json)
