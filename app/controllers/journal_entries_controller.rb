# frozen_string_literal: true

class JournalEntriesController < ApplicationController
  # GET /journal_entries
  # GET /journal_entries.json
  def index
    @journal_entries = JournalEntry.includes(:content).joins(:journal).where('journals.user': current_user)

    query_type = journal_entry_query_params[:type]
    query_journal = journal_entry_query_params[:journal_id]

    @journal_entries = @journal_entries.where(content_type: JournalEntry::VALID_CONTENT[query_type]) if query_type.present?
    @journal_entries = @journal_entries.where(journal_id: query_journal) if query_journal.present?
  end

  # GET /journal_entries/1
  # GET /journal_entries/1.json
  def show
    @journal_entry = JournalEntry.includes(:content).joins(:journal).where('journals.user': current_user).find(params[:id])
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def journal_entry_params
    params.fetch(:journal_entry, {}).permit(:journal_id, :content_id, :content_type)
  end

  def journal_entry_query_params
    request.query_parameters
  end
end
