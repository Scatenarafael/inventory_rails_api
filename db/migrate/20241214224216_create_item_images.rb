class CreateItemImages < ActiveRecord::Migration[8.0]
  def change
    create_table :item_images do |t|
      t.string :path
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
