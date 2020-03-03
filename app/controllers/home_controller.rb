# frozen_string_literal: true

class HomeController < ApplicationController
  def home; end

  def journal_entries
    @journal_entries = JournalEntry.includes(:content).joins(:journal).where('journals.user': current_user).where('journal_entries.journal_id': journal_ids).order(:entry_date) if journal_ids.present?
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def journal_ids
    raw_journal_ids = params.permit(:journal_ids)["journal_ids"]
    raw_journal_ids.split(",")
  end
end
