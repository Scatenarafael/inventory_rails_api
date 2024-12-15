class Sector < ApplicationRecord
  # has_and_belongs_to_many :room
  has_many :categories
end
