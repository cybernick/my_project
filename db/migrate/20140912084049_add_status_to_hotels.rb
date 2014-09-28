class AddStatusToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :status, :string, default: "pending"
  end
end
