class RemoveAddressFromHotels < ActiveRecord::Migration
  def change
    remove_column :hotels, :address, :text
  end
end
