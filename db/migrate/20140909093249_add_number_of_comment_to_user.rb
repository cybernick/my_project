class AddNumberOfCommentToUser < ActiveRecord::Migration
  def change
    add_column :users, :number_of_comment, :integer
  end
end
