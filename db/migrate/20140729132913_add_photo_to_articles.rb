class AddPhotoToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :name_of_photo, :string
  end
end
