class AddAdminIdToHotel < ActiveRecord::Migration
  def change
    add_column :hotels, :admin_id, :string
    add_column :hotels, :integer, :string
  end
end
