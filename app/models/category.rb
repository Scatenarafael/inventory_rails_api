class Category < ApplicationRecord
  belongs_to :sector
  has_many :items
end
