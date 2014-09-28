class AddNumberOfHotelToUser < ActiveRecord::Migration
  def change
    add_column :users, :number_of_hotel, :integer
  end
end
