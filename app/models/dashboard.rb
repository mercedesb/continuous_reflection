# frozen_string_literal: true

class Dashboard < ApplicationRecord
  belongs_to :user
  has_many :dashboard_components, dependent: :destroy
end
