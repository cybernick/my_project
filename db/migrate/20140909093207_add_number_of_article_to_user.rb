class AddNumberOfArticleToUser < ActiveRecord::Migration
  def change
    add_column :users, :number_of_article, :integer
  end
end
