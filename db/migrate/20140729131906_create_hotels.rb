class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.string :title
      t.string :string
      t.float :rating
      t.boolean :breakfast
      t.text :room_description
      t.float :price_for_room
      t.text :address
      t.integer :user_id

      t.timestamps
    end
  end
end
