class AddPhotoToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :name_of_photo, :string
  end
end
