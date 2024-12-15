class Item < ApplicationRecord
  belongs_to :category
  belongs_to :user
  belongs_to :room
end
