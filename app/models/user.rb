# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, uniqueness: true
end
