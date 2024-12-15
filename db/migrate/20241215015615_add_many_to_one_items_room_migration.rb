class AddManyToOneItemsRoomMigration < ActiveRecord::Migration[8.0]
  def change
    add_reference :items, :room, null: false, foreign_key: true
  end
end
